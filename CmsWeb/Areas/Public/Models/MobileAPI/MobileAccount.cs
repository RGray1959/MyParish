﻿using System;
using System.Linq;
using CmsData;
using CmsWeb.Models;
using UtilityExtensions;

namespace CmsWeb.MobileAPI
{
	public class MobileAccount
	{
	    private readonly CMSDataContext db;

	    public string First { get; set; }
	    public string Last { get; set; }
	    public string Email { get; set; }
	    public string Phone { get; set; }
	    public DateTime? Birthdate { get; set; }
        public User User { get; set; }
        public Person FoundPerson { get; set; }
        public Person NewPerson { get; set; }
        public string Result { get; set; }

	    public MobileAccount()
	    {
	        db = DbUtil.Db;
	    }
        public static MobileAccount Create(string first, string last, string email, string phone, string dob)
	    {
            var m = new MobileAccount
            {
                First = first,
                Last = last,
                Email = email.trim(),
                Phone = phone.GetDigits()
            };
            DateTime bd;
	        if (Util.DateValid(dob, out bd))
	            m.Birthdate = bd;
	        if (!Util.ValidEmail(m.Email))
	        {
	            m.Result = "email not valid";
	            return null;
	        }
            m.FindPersonSendAccountInfo();
            return m;
	    }

	    private void FindPersonSendAccountInfo()
	    {
	        var list = db.FindPerson(First, Last, Birthdate, Email, Phone).ToList();
	        var count = list.Count;
	        FoundPerson = count == 1 ? db.LoadPersonById(list[0].PeopleId ?? 0) : null;
	        if (FoundPerson == null)
	            CreateEmailNewUser();
	        else if (FoundPerson.EmailAddress.Equal(Email) || FoundPerson.EmailAddress2.Equal(Email))
	            EmailExistingPerson();
	        else
	            CreateEmailNewUserAndNotifyPersonFound();
	    }

	    private void CreateEmailNewUser()
        {
            var p = Person.Add(db, null, First, null, Last, Birthdate);
            p.EmailAddress = Email;
            p.HomePhone = Phone;
            db.SubmitChanges();
            User = MembershipService.CreateUser(db, p.PeopleId);
            var username = MembershipService.FetchUsername(db, First, Last);
            db.SubmitChanges();
            AccountModel.SendNewUserEmail(username);
            Result = "created new person/user";
        }

        private void EmailExistingPerson()
        {
            var message = db.ContentHtml("ExistingUserConfirmation", Resource1.CreateAccount_ExistingUser);
            message = message
                .Replace("{name}", FoundPerson.Name)
                .Replace("{host}", db.CmsHost);
            db.Email(DbUtil.AdminMail, FoundPerson, "Account information for " + db.Host, message);
            User = FoundPerson.Users.OrderByDescending(uu => uu.LastActivityDate).FirstOrDefault() 
                ?? MembershipService.CreateUser(db, FoundPerson.PeopleId);
            Result = "found existing person";
        }

        private void CreateEmailNewUserAndNotifyPersonFound()
        {
            CreateEmailNewUser();
            var message = db.ContentHtml("DuplicateUserOnMobile", Resource1.CreateNewUserAndNotifyPersonFound);
            db.Email(DbUtil.AdminMail, FoundPerson, "New User Account on " + db.Host, message);
            Result = "created new person/user, found person with different email";
        }
	}
}