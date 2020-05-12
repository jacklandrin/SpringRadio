# SpringRadio
![](http://www.jacklandrin.com/wp-content/uploads/2020/04/icon.png)

![](https://img.shields.io/badge/UI-SwiftUI-blue) ![](https://img.shields.io/badge/platform-iOS-lightgrey) ![](https://img.shields.io/badge/License-Apache-orange)
## What is SpringRadio?
**SpringRadio** is an online radio player with SwiftUI. The player control's background colour could change depending on station's image. Tapping the image on player control, will go to the detail page where there are some floating Text animation. The orientations include horizontal and vertical and it can randomly display. The inspiration comes from Microsoft MP3, Zune HD.

![list](http://www.jacklandrin.com/wp-content/uploads/2020/04/spring_radio_list.gif)

The detail page:

![animation](http://www.jacklandrin.com/wp-content/uploads/2020/04/spring_radio_detail-1.gif)

The git address is <https://github.com/jacklandrin/SpringRadio>

## About Sound Wave of Realtime Audio
The effect of sound wave derives from **AudioSpectrum**. Its developer describes the details in his blogs. The essential is analysis of the audio's PCM buffer to calculate a Hanning Window graph. Thus, how to seize PCM buffer from a realtime stream audio is a question, because AVPlayer can't do that.

I modified **AudioStreamer** that is an audio player with **AudioToolbox** to implement it. This player contains a Downloader to send a HTTP request to get audio data. Then the Parser can collect these data and process them. While AVPlayNode is commanded to play the audio, the Reader will read the packets collected from Parser. After that, Reader create **AVAudioPCMBuffer** based on these packets, and it send the buffer to PlayerNode. The AudioEngine could callback the buffer that is playing via **installTap** function of its **mainMixerNode**.

Like this, these pieces of buffer can be put into AudioSpectrum's **RealtimeAnalyzer** to generate the sound wave data, and SpectrumView will render them to display the wave.

![](http://www.jacklandrin.com/wp-content/uploads/2020/04/SpringRadio.png)

Since AudioStreamer is not originally designed for realtime audio, the Parser collects the data downloaded until request completing, which causes memory issue for online radio. So, I added a strategy, which the Reader will remove certain numbers of packets of Parser in case this problem, while the Reader consume certain account of data. Besides, while the PlayNode schedules the buffer, the function will check if there are enough packets to be read in case audio stalling.

## Requirement
* iOS 13
* Swift 5.2
* Xcode 11

## References
I referenced these projects:
* [RadioMinimal](https://github.com/SergeyPetrovi4/RadioMinimal)
* [dominant-color-swift](https://github.com/neriusv/dominant-color-swift-sample)
* [AudioStreamer](https://github.com/syedhali/AudioStreamer)
* [AudioSpectrum](https://github.com/potato04/AudioSpectrum)

## License
Apache

## Others
You can add other online radio items from this website <https://www.internet-radio.com>