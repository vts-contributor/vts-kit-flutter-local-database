

# vts_sqflite - Fork from [sqflite (tekartik) ](https://github.com/tekartik/sqflite) to implement SQLCipher

SQLite plugin for [Flutter](https://flutter.io).    
Supports iOS, Android.

### This plugin is a fork so it can be used just like [sqflite](https://github.com/tekartik/sqflite) but with some additional functions.

We support new password argument for opening databases.  
```dart Database database = await openDatabase('test.db', password: '@123sas3559'); // you shouldn't hard code the password here, maybe hash it and store to shared preferences. ``` New methods:
 ```dart //encrypt a plain text database with new passwordawait encryptDatabase('test.db', '@sdasfa'); //decrypt an encrypted database, the password must be correct for the encrypted database await decryptDatabase('test.db', '@sdasfa');    
 //change password await changePassword(database, 'djkl123');    
 ```  

### Important notes
#### Android
##### ProGuard (REQUIRED)
You must enable ProGuard for your release app and add this line to your custom proguard-rules  file:  
```text -keep class net.zetetic.database.sqlcipher.** { *; } ``` For details, if this line isn't added, your app will crash on start because of Android shrinking and obfuscation when you run the app in release mode:
```  
Throwing new exception 'no "I" field "numArgs" in class "Lnet/zetetic/database/sqlcipher/SQLiteCustomFunction;"  
```  
If you don't know how to enable ProGuard for your project, follow these steps:
* Step 1: Add these lines to your app build.gradle file (`android/app/build.gradle`):
```groovy  
buildTypes {    
  release {    
     minifyEnabled true   //this line  
     shrinkResources true    //this line 
     proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'   //this line 
     signingConfig signingConfigs.debug   
  }    
  debug {    
     signingConfig signingConfigs.debug    
  } 
}  
```  
* Step 2: create file `proguard-rules.pro` in folder `android/app` (same location as build.gradle file)
* Step 3: Add the `-keep ... ` line that we mentioned before.
* 
#### iOS
<b> If you're using sqflite at directive or transitive dependency (have one or more package that depends on sqflite like cached_network_image...), please check this [fix from davidmartos96](https://github.com/davidmartos96/sqflite_sqlcipher/tree/master/sqflite#if-using-sqflite-as-direct-or-transitive-dependency) </b>
 Your app will crash whenever you use sqflite or vts_sqflite if you don't apply the above fix.