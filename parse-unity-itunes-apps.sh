#!/bin/bash
# Parses your itunes app binaries for libraries and frameworks
# Stores output on your Desktop or overrider file
# see prefs.properties



set -x

source config.properties

# source templates/$1.template

# for key in ${!executableFile[@]}; do
#     echo "executableFile[$key] = ${executableFile[$key]}"
# done

# exit

pushd "$itunesLibrary"

echo "Output started..." > $outputLog


echo "Name,Icon,ID,Executable,Unity,Cocos2d,AdobeAIR,Marmalade,Corona,Facebook,Mobage,HTML,Tapjoy,Appoxee,Parse,P31,NGUI,2DToolkit" > $output

FILES=*.ipa
for f in *; do
   rm -rf $tempDirectory
   mkdir $tempDirectory
   cp -R "$f" "$tempDirectory/$f.zip"
   unzip "$tempDirectory/$f.zip" -d "$tempDirectory/extracted"


   # Get name
   name=`/usr/libexec/PlistBuddy -c "Print :CFBundleName" $tempDirectory/extracted/*/*/Info.plist`
   # Get id
   id=`/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" $tempDirectory/extracted/*/*/Info.plist`
   # Get icone display
   icon=`/usr/libexec/PlistBuddy -c "Print :CFBundleDisplayName" $tempDirectory/extracted/*/*/Info.plist`
   # Get executable name
   executable=`/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" $tempDirectory/extracted/*/*/Info.plist`

   rawOutput=$tempDirectory/outputFiles.log
   find "$tempDirectory/extracted" >> $rawOutput

   if [ -z "`grep 'FacebookSDKResources\|FBUserSettings' $rawOutput`" ]; then
      facebook=N
   else
      facebook=Y
   fi

   if [ -z "`grep 'TapjoyResources' $rawOutput`" ]; then
      tapjoy=N
   else
      tapjoy=Y
   fi

   if [ -z "`grep '/AIR' $rawOutput`" ]; then
      adobeAir=N
   else
      adobeAir=Y
   fi

   if [ -z "`grep 'UnityEngine' $rawOutput`" ]; then
      unity=N
   else
      unity=Y
   fi

   if [ -z "`grep 'AppoxeeResources' $rawOutput`" ]; then
      appoxee=N
   else
      appoxee=Y
   fi

   if [ -z "`grep 'NDKResources' $rawOutput`" ]; then
      mobage=N
   else
      mobage=Y
   fi

   if [ -z "`grep '.html' $rawOutput`" ]; then
      html=N
   else
      html=Y
   fi

   if [ -z "`grep 'Parse.Unity.dll' $rawOutput`" ]; then
      parse=N
   else
      parse=Y
   fi

   if [ -z "`grep 'Corona' $rawOutput`" ]; then
      corona=N
   else
      corona=Y
   fi

   if [ -z "`grep 'Marmalade' $tempDirectory/extracted/*/*/$executable`" ]; then
      marmalade=N
   else
      marmalade=Y
   fi

   if [ -z "`grep 'cocos2d' $tempDirectory/extracted/*/*/$executable`" ]; then
      cocos=N
   else
      cocos=Y
   fi

   if [ -z "`grep 'P31Unity' $tempDirectory/extracted/*/*/$executable`" ]; then
      p31unity=N
   else
      p31unity=Y
   fi


   if [ -z "`grep 'NGUITools' $tempDirectory/extracted/*/*/$executable`" ]; then
      ngui=N
   else
      ngui=Y
   fi

   if [ -z "`grep '2k2dSystem' $tempDirectory/extracted/*/*/$executable`" ]; then
      twoToolkit=N
   else
      twoToolkit=Y
   fi


   # write contents 
   echo "$name,$icon,$id,$executable,$unity,$cocos,$adobeAir,$marmalade,$corona,$facebook,$mobage,$html,$tapjoy,$appoxee,$parse,$p31unity,$ngui,$twoToolkit" >> $output

done

popd
