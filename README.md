# PagerTabStripView

<p align="left">
<!-- <a href="https://travis-ci.org/xmartlabs/PagerTabStrip"><img src="https://travis-ci.org/xmartlabs/PagerTabStrip.svg?branch=master" alt="Build status" /></a> -->
<a href="https://github.com/xmartlabs/PagerTabStripView/actions/workflows/build-test.yml"><img src="https://github.com/xmartlabs/PagerTabStripView/actions/workflows/build-test.yml/badge.svg" alt="build and test" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift5-compatible-4BC51D.svg?style=flat" alt="Swift 5 compatible" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://cocoapods.org/pods/PagerTabStripView"><img src="https://img.shields.io/cocoapods/v/PagerTabStripView.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/xmartlabs/PagerTabStripView/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

Made with :heart: by [Xmartlabs](http://xmartlabs.com) team. [XLPagerTabStrip](https://github.com/xmartlabs/XLPagerTabStrip) for SwiftUI!

## Introduction

PagerTabStripView is the first pager view built in pure SwiftUI. It provides a component to create interactive pager views which contains child views. It allows the user to switch between your views either by swiping or tapping a tab bar item.

<table>
  <tr>
    <th><img src="Example/Media/twitterStyleExample.gif" width="250"/></th>
    <th><img src="Example/Media/instagramStyleExample.gif" width="250"/></th>
    <th><img src="Example/Media/LogOutExample.gif" width="250"/></th>
  </tr>
</table>

Unlike Apple's TabView it provides:
1. Flexible way to fully customize pager tab views.
2. Each pagerTabItem view can be of different type.
3. Bar that contains pager tab item is placed on top.
4. Indicator view indicates selected child view.
5. `onPageAppear` callback to easily trigger actions when page is selected.
6. Ability to update pagerTabItem according to highlighted, selected, normal state.

..and we've planned many more functionalities, we have plans to support each one of the XLPagerTabStrip [styles](https://github.com/xmartlabs/XLPagerTabStrip#pager-types).

## Usage

Creating a page view is super straightforward, you just need to place your custom tab views into a `PagerTabStripView` view and apply the `pagerTabItem( _: )` modifier to each one to specify its navigation bar tab item.

```swift
import PagerTabStripView

struct MyPagerView: View {

    var body: some View {

        PagerTabStripView() {
            MyFirstView()
                .pagerTabItem {
                    TitleNavBarItem(title: "Tab 1")
                }
            MySecondView()
                .pagerTabItem {
                    TitleNavBarItem(title: "Tab 2")
                }
            if User.isLoggedIn {
                MyProfileView()
                    .pagerTabItem {
                        TitleNavBarItem(title: "Profile")
                    }
            }
        }

    }
}
```

<div style="text-align:center">
    <img src="Example/Media/defaultExample.gif">
</div>

</br>
</br>

To specify the initial selected page you can pass the `selection` init parameter.

```swift
struct MyPagerView: View {

    @State var selection = 1

    var body: some View {
        PagerTabStripView(selection: $selection) {
            MyFirstView()
                .pagerTabItem {
                    TitleNavBarItem(title: "Tab 1")
                }
            ...
            ..
            .
        }
    }
}
```

As you may've already noticed, everything is SwiftUI code, so you can update the child views according to SwiftUI state objects as shown above with `if User.isLoggedIn`.

### Customize pager style

You have the ability to customize some aspects of the navigation bar and its indicator bar using the `pagerTabStripViewStyle` modifier. The customizable settings are:

-   Spacing between navigation bar items
-   Navigation bar height
-   Indicator bar height
-   Indicator bar color

```swift
struct PagerView: View {

	var body: some View {
		PagerTabStripView(selection: 1) {
			MyView()
				.pagerTabItem {
					TitleNavBarItem(title: "Tab 1")
				}
			AnotherView()
				.pagerTabItem {
					TitleNavBarItem(title: "Tab 2")
				}
			if User.isLoggedIn {
				ProfileView()
					.pagerTabItem {
						TitleNavBarItem(title: "Profile")
                    }
			}
		}
        	.pagerTabStripViewStyle(PagerTabViewStyle(tabItemSpacing: 0, tabItemHeight: 50, indicatorBarHeight: 2, indicatorBarColor: .gray))
	}
}
```

In this example, we add some settings like the tab bar height, indicator bar color and indicator bar height. Let's watch how it looks!

<div style="text-align:center">
    <img src="Example/Media/addPagerSettings.gif">
</div>

### Navigation bar

The navigation bar supports custom tab items. You need to specify its appearance creating a struct that implements `View` protocol.

For simplicity, we are going to implement a nav bar item with only a title. You can find more examples in the example app.

```swift
struct TitleNavBarItem: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(Color.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
```

#### Customize selected and highlighted items

You can define the style of your nav items when they are selected or highlighted by conforming `PagerTabViewDelegate` protocol in your nav item view.

In the following example we change the text and background color when the tab is highlighted and selected.

```swift
private class NavTabViewTheme: ObservableObject {
    @Published var textColor = Color.gray
    @Published var backgroundColor = Color.white
}

struct TitleNavBarItem: View, PagerTabViewDelegate {
    let title: String
    @ObservedObject fileprivate var theme = NavItemTheme()

    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(theme.textColor)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundColor)
    }

    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.textColor = .blue
            self.theme.backgroundColor = .lightGray
        case .highlighted:
            self.theme.textColor = .pink
        default:
            self.theme.textColor = .gray
            self.theme.backgroundColor = .white
        }
    }
}
```

<div style="text-align:center">
    <img src="Example/Media/setStateCallback.gif">
</div>

### onPageAppear modifier

`onPageAppear` callback allows you to trigger some action when a page view gets selected, either by scrolling to it or tapping its tab. This modifier is applied only to its associated page view.

```swift
struct PagerView: View {

    var body: some View {
        PagerTabStripView(selection: 1) {
            MyView(model: myViewModel)
                .pagerTabItem {
                    TitleNavBarItem(title: "Tab 1")
                }
                .onPageAppear {
                    model.reload()
                }
        }
        .pagerTabStripViewStyle(PagerTabViewStyle(tabItemSpacing: 0, tabItemHeight: 50, indicatorBarHeight: 2, indicatorBarColor: .gray))
    }
}
```

## Examples

Follow these 3 steps to run Example project
* Clone PagerTabStripView repo.
* Open PagerTabStripView workspace.
* Run the _Example_ project.

## Installation

### CocoaPods

To install PagerTabStripView using CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'PagerTabStripView', '~> 1.0'
```

### Carthage

To install PagerTabStripView using Carthage, simply add the following line to your Cartfile:

```ruby
github "xmartlabs/PagerTabStripView" ~> 1.0
```

## Requirements

-   iOS 14+
-   Xcode 12.X

## Author

-   [Xmartlabs SRL](https://github.com/xmartlabs) ([@xmartlabs](https://twitter.com/xmartlabs))

## Getting involved

-   If you **want to contribute** please feel free to **submit pull requests**.
-   If you **have a feature request** please **open an issue**.
-   If you **found a bug** or **need help** please **check older issues and threads on [StackOverflow](http://stackoverflow.com/questions/tagged/PagerTabStripView) (Tag 'PagerTabStripView') before submitting an issue**.

Before contribute check the [CONTRIBUTING](https://github.com/xmartlabs/PagerTabStripView/blob/master/CONTRIBUTING.md) file for more info.

If you use **PagerTabStripView** in your app We would love to hear about it! Drop us a line on [Twitter](https://twitter.com/xmartlabs).
