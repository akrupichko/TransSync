import Foundation

extension String {
    public static let helpString = """
\u{1F504} TransSync is the utilite for sync the localizations in Xcode projects \u{1F504}

\u{1F4DA} For sync needs the paths to the localization resource, that contains the *.lproj directories in the developing project and in the project with actual translates.

Directory with the translates in the Xcode projects, looks like:
/Project/
    Strings/
        en.lproj/...
        fr.lproj/...
        az.lproj/...

In this example, you need the Strings direcotory.

\u{1F4D6} Arguments:
-u {path}           // Path for update
-t {path}           // Path with the actual translates
-k {key},{key},...  // Keys for update. You can use -k with keys, that exactly will updated.
-c {path}           // Will copy key = value from the master file to the all languages. Must be used with the -k argument.

\u{1F921} Exampes:

\u{1F4CB}
Will updates values in all localization in directory  "/ProjectInDevelopment/Resources/Strings".
Values will get form the directory "/ProjectWithActualTranslates/Resources/Strings"

./TransSync -u /ProjectInDevelopment/Resources/Strings -t /ProjectWithActualTranslates/Resources/Strings

\u{1F4CB}
Will updates values in all localization in directory  "/ProjectInDevelopment/Resources/Strings".
Values will get form the directory "/ProjectWithActualTranslates/Resources/Strings"
But only for keys: button_title and button_description

./TransSync -u /ProjectInDevelopment/Resources/Strings -t /ProjectWithActualTranslates/Resources/Strings -k button_title,button_description
"""
}
