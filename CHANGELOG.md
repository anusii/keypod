# KeyPod App Changelog

Recorded here are the high level changes for the GYSAC Patient
(indipod) app.

Instructions: Add the updates beyond, for example, 0.6.0 under the 0.7
heading, adding to the top of the list, and recording minor version
numbers.

## 0.6 FUTURE

+ Separate the demo/test into solidpod itself [0.5.10]
+ Show webId on demo page if user has logged in [0.5.9]
+ Demo: Check and grant access permissions [0.5.8]
+ Demonstrate the implementation of validating input security keys [0.5.7]
+ Demonstrate the use of the same filename to store encrypted/unencrypted data [0.5.6]
+ Fix: not redirecting back to demo page from basic key-value editor [0.5.5]
+ Add logout icon button to home page [0.5.4]
+ Demonstrate the delete of individual key when deleting an encrypted data file [0.5.3]
+ Demonstrate the read/write of non-encrypted data file [0.5.2]
+ Fix: not redirecting appropriately after initialising POD [0.5.1]

## 0.5 20240522

+ Update license to GPL. [0.4.14]
+ Remove binary installers from default branch for migrating them to Git LFS [0.4.13]
+ Review and cleanup code [0.4.12]
+ Add a data table widget to view, insert, edit, delete rows of key-value pairs [0.4.11]
+ Use updated API to remove security key from local secure storage. [0.4.10]
+ Add a logout button for users to logout. [0.4.9]
+ Bug prevents showing data right after initialising POD [0.4.8]
+ Remove hard-coded app name. Obtain the name from solidpod. [0.4.7]
+ changeKeyPopup() popup window for changing the security key. [0.4.6]
+ Add functions to generate/parse TTL string from/to key-value pairs [0.4.5]
+ Add a basic key-value editor to demonstrate the writePod function [0.4.4]
+ Split About Dialog into own file about.dart [0.4.3]
+ Show busy icon when viewing private data. [0.4.2]
+ Override the version of intl for solid-auth. [0.4.1]

## 0.4 

+ Add an About dialog [0.3.4]
+ Added popupLogin into the continue placeholder page. 
+ Package solid renamed to solidpod.
+ Begin managing versions and releases.
+ Basic functionality of solid login.
+ Fine tuning of GUI.
