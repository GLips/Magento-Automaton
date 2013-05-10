Magento Automaton
=================

Script used at Customer Paradigm to pull down and setup development sites
automatically.

Documentation:

1. Navigate to the site's root folder
2. Run `cat app/etc/local.xml`
3. Run `wget http://dev.customerparadigm.com/~graham/scripts/assets/downloads/cp_remote.sh && bash cp_remote.sh`
6. Wait until the script prompts you for your CP dev server password and supply it.
7. SSH into your public_html folder on the CP dev site
8. Run `cp_local`
9. Update app/etc/local.xml to use the dev server's MySQL credentials.
