# DigitizedHME
For the digitization of hand-written mathematical expressions. I used 32,200 samples obtained from Kaggle's 100,000 character dataset for training
and another 3,220 characters for testing. I implemented a modified Faruqui approach only to revert to a transfer learning network which gave better accuracy.

The networks developed were two, one (model 22) was a modified version of N. Faruqui's which I found on his YT channel, another (model 17) was a transfer learning
network adapted from SqueezeNet.

Model 17 gave an accuracy of 87.5% on Kaggle's data, while model 22 gave an accuracy of 85.54%.

The app developed performed far quicker than the online TextScanner (available here: https://play.google.com/store/apps/details?id=image.to.text.ocr&hl=en&gl=US)
and had a greater accuracy than Office Lens (available: https://play.google.com/store/apps/details?id=com.microsoft.office.officelens&hl=en&gl=US) at recgnizing
handwritten equations written by seven participants.

Message me on LinkedIn for full report
LinkedIn URL: https://www.linkedin.com/in/timothysawe/
