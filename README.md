# kls-ios-swift

### 개요
Kollus Player iOS SDK의 Swift 샘플
- 기본적인 재생
- 백그라운드 재생

### 백그라운드 재생 설정
Background Mode capabilities 중 [Audio, Airplay, and Picture in Picture] 속성을 활성화 시켜준다.
info.list
```
<key>UIBackgroundModes</key>
	<array>
		<string>audio</string>
		<string>bluetooth-central</string>
		<string>fetch</string>
		<string>processing</string>
</array>
```

Background 재생 제어를 위한 MPRemoteCommandCeter와 Kollus Player를 연동 한다
[Sample Code](https://github.com/kollus-service/kls-ios-swift/blob/1fa86481b2e1529494bb02326a56d755c4aea7d6/KLS-ExamplePlayer/Player/Extension/BackgroundPlayExtension.swift)

See Also.
- [Enabling Background Audio](https://developer.apple.com/documentation/avfoundation/media_playback/creating_a_basic_video_player_ios_and_tvos/enabling_background_audio)
- [Controlling Background Audio](https://developer.apple.com/documentation/avfoundation/media_playback/creating_a_basic_video_player_ios_and_tvos/controlling_background_audio)
