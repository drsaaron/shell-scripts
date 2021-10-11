#! /bin/sh

cd ~/NetBeansProjects/BlazarJavaBase
updateImage.sh

bulkMavenUpdate.sh BlazarCryptoFile BlazarFacebookClient BlazarJobManager BlazarMailer BlazarMailer-springImpl DateServices TelegramClient QuoteOfTheDay-data QuoteOfTheDay-data-jpaImpl QuoteOfTheDay-process QuoteOfTheDayServices QuoteOfTheDayJob
