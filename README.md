# TransSync
TransSync is the utilite for sync the localizations in Xcode projects

## Installation
Command will build the utilite in the current directory:
```
xcodebuild -scheme TransSync DSTROOT="." archive
```
## Usage
```
cd {archive path from installation step}/usr/local/bin
```
```
./TransSync -u /{ProjectInDevelopment}/Resources/Strings -t /{ProjectWithActualTranslates}/Resources/Strings
```
For sync needs the paths to the localization resource, that contains the *.lproj directories in the developing project (**-u**) and in the project with actual translates (**-t**).

Directory with the translates in the Xcode projects, looks like:
```
/Project/
    Strings/
        en.lproj/...
        fr.lproj/...
        az.lproj/...
```

In this example, you need the Strings direcotory.

Possible frguments:
```
-u {path}           // Path for update
-t {path}           // Path with the actual translates
-k {key},{key},...  // Keys for update. You can use -k with keys, that exactly will updated.
-h                  // Help
```

## Exampes

Will updates values in all localization in directory  "/ProjectInDevelopment/Resources/Strings".
Values will get form the directory "/ProjectWithActualTranslates/Resources/Strings"
```
./TransSync -u /ProjectInDevelopment/Resources/Strings -t /ProjectWithActualTranslates/Resources/Strings
```

Will updates values in all localization in directory  "/ProjectInDevelopment/Resources/Strings".
Values will get form the directory "/ProjectWithActualTranslates/Resources/Strings"
But only for keys: button_title and button_description
```
./TransSync -u /ProjectInDevelopment/Resources/Strings -t /ProjectWithActualTranslates/Resources/Strings -k button_title,button_description
```
