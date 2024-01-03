# Automate the sending of emails

The application allows you to automatically send emails at regular intervals to identified mailboxes, to indicate :

- events concerning samples that are about to expire;
- samples that are about to become obsolete (expiry date approaching).

Two types of parameter must be set in order to activate this functionality, and a script must also be programmed in the server to trigger the operation.

The sending parameters are defined per collection, which means that different recipients can be defined for each one. The emails contain a list of the samples concerned.

The application is not currently configured to handle events involving containers.

## Activate global mail generation

In the application's general parameters (*Administration > Application parameters*), set the **notificationDelay** value to 7 (value greater than 0). This is the number of days between two mailings.

Then add programming to the server, while connected *root*:

~~~bash
echo "0 8 * * * /var/www/collec-science/collec-science/collectionsGenerateMail.sh" | crontab -u www-data -
chmod +x /var/www/collec-science/collec-science/collectionsGenerateMail.sh
~~~

Check that the path to the executed file (*collectionGenerateMail.sh*) is correct. If it is not, you will also need to edit this file and change the path (line 2 of the file).

The script will run every day at 8am. If the date in the **notificationLastDate** field is older than the time specified above, the program will search for samples in the relevant collections and send emails if any are found.

## Configure the collections to activate the sending of emails

In *Settings > Collections*, go into edit mode for the collection for which you want to activate emailing. Go to the *Notifications* tab and fill in the following information:

- tick to enable notifications
- enter the list of recipient emails, separated by a comma
- enter the number of days before the due dates, a value of 0 disables the search for the samples concerned (event due date or sample expiry date).

## Send emails manually

If you want to (re)start sending emails :

- in the application's general settings (*Administration > Application settings*), delete the date that may be present in the **notificationLastDate** field;
- call up the page [index.php?module=collectionsGenerateMail](index.php?module=collectionsGenerateMail)

No information will be displayed on the screen (blank page). You can return to the application settings to check that the **notificationLastDate** field has been updated.
