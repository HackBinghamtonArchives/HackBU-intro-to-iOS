# Mobile Development for iOS Devices


# Getting Started

In this workshop we will be focusing on native iOS development in Swift using the IDE Xcode (this will assume that you have access to a Mac device). For a guide on installing Xcode, version 10, check out: https://developer.apple.com/xcode/ide/.
&nbsp;
Don't have a Mac? &nbsp;
  Apple is commonly cited as having made MacOS a requirement for iOS development. On the contrary, iOS apps can be built and deployed from start to finish without a Mac. However, the iOS SDK is only available on MacOS, and the Xcode IDE is highly optimized for iOS development. The differences between using Xcode and Swift, as opposed to Xamarin Studio and C#, for example, can be a bit nuanced, so I implore you to try whichever languages and/or technologies you are comfortable with. There are plenty of options ranging from virtual machines, cross-platform IDEs, mobile-hybrid frameworks, etc. Personally, I started developing mobile apps using an awesome framework released by Microsoft, called Xamarin, which allows you to build mobile apps for Android and iOS in C#, without owning a Mac.


# Today's Project

Today's workshop will be an introduction to iOS development. After completing this workshop, you should be comfortable with Xcode, and able to implement some basic functionality in Swift. I've added resources to a small demo app, a social networking platform that uses geolocations to chat and network with users (Binghamton students) within the vicinity of each other, whether they are on campus, or anywhere else in the U.S. The project can be cloned to your machine and you are free to run/edit it as much as you'd like. In this workshop we will look at some beginner and intermediate functionality of iOS development. Unfortunately, we do not have time to go over Swift. Swift is a high-level language that is syntactically similar to Ruby or Python. It is quite easy to pick up for anyone with experience in object-oriented programming. Two things to note about Swift are its use of optionals, and its lack of primitive data types. In Swift, types such as Int and Double have a default value of nil, rather than 0, like in other languages.

# Technologies

We will be working in Swift. We will use Firebase's no-SQL database for user authentication, storing and retrieving metadata such as images, as well as logging messages. Lastly, we will use the GoogleMaps/GooglePlaces APIs for user geolocation.

<img src="https://cdn2.macworld.co.uk/cmsdata/features/3597812/how-to-learn-swift-4_thumb800.jpg"
     alt="Swift icon"
     height="70" width="140" />

<img src="https://firebase.google.com/images/brand-guidelines/logo-standard.png"
     alt="Firebase icon"
     height="70" width="140" />


# Sections


<a href="Visual-Interfaces.md">Building Visual Interfaces</a>
  Intro to Xcode
  Designing Visual Interfaces
  Segues


<a href="ViewControllers.md">View Controllers</a>
  IBOutlets and IBActions
  Making Your Visual Interfaces Interactive
  Passing Data Between View Controllers


<a href="Frameworks.md">CocoaPods, APIs, and Frameworks</a>
  What is CocoaPods?
  Adding, Installing, and Updating Pods

<a href="Firebase.md">Firebase Integration</a>
  What is Firebase?
  Setting Up
  User Authentication
  Posting User Data
  Fetching User Data

<a href="Conclusion.md">Wrapping Up</a>
  Testing, Building, and Deploying
  Custom UI Views
  Pros and Cons of Firebase
  Constraints
  Next Steps
