
# This file describe what service you are and
# what offerings you propose. The values in this
# file will be used to customize the forms and email
# messages that the users will see.
class NewAccountOfferings

   # A short name for the organization offering
   # the new account. It will usually be used in
   # a context where a leading "THE" will be required,
   # so make sure it sounds good that way.
   TheOrganizationShortName = "The Organization"

   # Enter the 'FROM' value for the emails that will
   # be sent for confirmation.
   EmailFrom = 'noreply@example.com'

   # A list of services that will be shown in the new request form.
   # Provide a short, one line description, and the main URL for the service.
   # This list will be shown in a selection box in the
   # main form.
   ServiceList = {
     'User Account'           => [ 'A normal user account',                            'http://www.example.com/' ],
     'Data Access'            => [ 'Access to the data in read-only mode',             'http://www.example.com/' ],
     'Mailing List'           => [ 'I want to be added to the mailing list',           'http://www.example.com/' ],
     'Root Access'            => [ 'Root access: Hey I want to delete all your files!' 'http://www.example.com/' ],
   }

   # Admin email address(es) for notification of new requests.
   # This should be the email address of a real person,
   # who will receive a message each time someone makes
   # a request for a service. You can put more than one
   # address in the string, each separated by commas.
   AdminNotificationEmail = 'real_admin_user@example.com.REPLACE_THIS'

   # The encrypted password to enter admin mode.
   # You can generated it by choosing RANDOMLY some
   # seed word (such as 'z2') and a real password
   # and running this Ruby one-liner:
   #
   #   ruby -rDigest -e 'seed="z2";pw="mypassword";puts seed+","+Digest::MD5.hexdigest("#{seed}#{pw}")'
   #
   # You'll get a string with the original seed word, a comma, and
   # a 32 characters MD5 hash. The full string needs to be set as the
   # value of the constant below.
   AdminPassword = 'ox,ea280f79274d11af5d9a723a1348cf41'

   # List of usernames you accept as 'admins'
   AdminUsernames = [ 'prioux', 'mero' ]

end

