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
    <th><img src="Example/Media/scrollableStyleExample.gif" width="250"/></th>
  </tr>
</table>

Unlike Apple's TabView it provides:

1. Flexible way to fully customize pager tab views.
2. Each pagerTabItem view can be of different type.
3. Bar that contains pager tab item is placed on top.
4. Indicator view indicates selected child view.
5. Ability to update pagerTabItem according to highlighted, selected, normal state.

..and we've planned many more functionalities, we have plans to support each one of the XLPagerTabStrip [styles](https://github.com/xmartlabs/XLPagerTabStrip#pager-types).

## Usage

Creating a page view is super straightforward, you just need to place your custom tab views into a `PagerTabStripView` view and apply the `pagerTabItem` modifier to each one to specify its navigation bar tab item.
The `tag` parameter is the value to identify the tab item.

```swift
import PagerTabStripView

struct MyPagerView: View {

    var body: some View {

        PagerTabStripView() {
            MyFirstView()
                .pagerTabItem(tag: 1) {
                    TitleNavBarItem(title: "Tab 1")
                }
            MySecondView()
                .pagerTabItem(tag: 2) {
                    TitleNavBarItem(title: "Tab 2")
                }
            if User.isLoggedIn {
                MyProfileView()
                    .pagerTabItem(tag: 3) {
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

To specify the initial selected page you can pass the `selection` init parameter (for it to work properly this value have to be equal to some tag value of the tab items).

```swift
struct MyPagerView: View {

    @State var selection = 1

    var body: some View {
        PagerTabStripView(selection: $selection) {
            MyFirstView()
                .pagerTabItem(tag: 1) {
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

The user can also configure if the swipe action is enable or not (the swipe is based on a drag gesture) and setup what edges have the gesture disabled.

Params:
- `swipeGestureEnabled`: swipe is enabled or not (default is true).
- `edgeSwipeGestureDisabled`: is an HorizontalContainerEdge (OptionSet) value where the array could have this options: .left, .right, .both or be empty (default is an empty array).

What is the importance to have this parameter?
Regarding the next PagerTabStripView example in `MyPagerView2`: if the pager is in the first page and the user try to swipe to the left, is possible to catch a parent view gesture (where this pager is embebbed) instead of catching the actual pager swipe gesture because it is disabled with the `edgeSwipeGestureDisabled` paramenter.

```swift
struct MyPagerView2: View {

    @State var selection = 1

    var body: some View {
        PagerTabStripView(swipeGestureEnabled: .constant(true),	
			  edgeSwipeGestureDisabled: .constant([.left]),
			  selection: $selection) {
            MyFirstView()
                .pagerTabItem(tag: 1) {
                    TitleNavBarItem(title: "Tab 1")
                }
            ...
            ..
            .
        }
    }
}
```


### Customize pager style

PagerTabStripView provides 5 different ways to show the views. You can select it and customize some aspects of each one using the `pagerTabStripViewStyle` modifier.

#### Scrollable style

In this style you can add as many pages as you want. The tabs are placed in a scroll.

The customizable settings are:
- Placed in toolbar
- Pager animation when appear
- Spacing between navigation bar items
- Navigation bar items height
- Padding to insets
- Bar background view
- Indicator view 
- Indicator view height

```swift
struct PagerView: View {

	var body: some View {
		PagerTabStripView(selection: 1) {
			MyView()
				.pagerTabItem(tag: 1) {
					TitleNavBarItem(title: "First big width")
				}
			AnotherView()
				.pagerTabItem(tag: 2) {
					TitleNavBarItem(title: "Short")
				}
            ...
            ..
            .

		}
        .pagerTabStripViewStyle(.scrollableBarButton(tabItemSpacing: 15, 
						     tabItemHeight: 50, 
	    					     indicatorView: {
            						Rectangle().fill(.blue).cornerRadius(5)
            					     }))
	}
}
```

In this example, we add some settings like the tab bar height, indicator view and tab item spaces. Let's see how it looks!

<div style="text-align:center">
    <img src="Example/Media/scrollableStyleExample.gif">
</div>

#### Button bar style

The customizable settings are:
- Placed in toolbar
- Pager animation when appear
- Spacing between navigation bar items
- Navigation bar items height
- Padding to insets
- Bar background view
- Indicator view 
- Indicator view height

```swift
struct PagerView: View {

	var body: some View {
		PagerTabStripView(selection: 1) {
			MyView()
				.pagerTabItem(tag: 1) {
					TitleNavBarItem(title: "Tab 1")
				}
			AnotherView()
				.pagerTabItem(tag: 2) {
					TitleNavBarItem(title: "Tab 2")
				}
			if User.isLoggedIn {
				ProfileView()
					.pagerTabItem(tag: 3) {
						TitleNavBarItem(title: "Profile")
                    }
			}
		}
        .pagerTabStripViewStyle(.barButton(tabItemSpacing: 15, 
					   tabItemHeight: 50, 
	    			           indicatorView: {
            				   	Rectangle().fill(.gray).cornerRadius(5)
            				   }))
	}
}
```

In this example, we add some settings like the tab bar height, indicator view and indicator bar height. Let's see how it looks!

<div style="text-align:center">
    <img src="Example/Media/addPagerSettings.gif">
</div>

#### Bar style

This style only shows a bar that indicates the current view controller. 

The customizable settings are:
- Placed in toolbar
- Pager animation when appear
- Indicator view 
- Indicator view height

<div style="text-align:center">
    <img src="Example/Media/barStyleExample.gif">
</div>

#### Segmented style

This style uses a Segmented Picker to indicate which view is being displayed. You can indicate the selected color, its padding and if you want it to be set in the toolbar.

The customizable settings are:
- Placed in toolbar
- Pager animation when appear
- Background color
- Padding to insets

<div style="text-align:center">
    <img src="Example/Media/segmentedStyleExample.gif">
</div>

#### Custom style

The styles uses the provided view to indicate and background Views to create the item bar. You can use any and fully customized Views for the indicator and the background view in any way you need.

```
        .pagerTabStripViewStyle(.barButton(placedInToolbar: false,
                                           pagerAnimation: .interactiveSpring(response: 0.5,
                                                                              dampingFraction: 1.00,
                                                                              blendDuration: 0.25),
                                           tabItemHeight: 48,
                                           barBackgroundView: {
            LinearGradient(
               colors: 🌈,
               startPoint: .topLeading,
               endPoint: .bottomTrailing
           )
           .opacity(0.2)
        }, indicatorView: {
            Text("👍🏻").offset(x: 0, y: -24)
        }))
```

See how it looks:

<div style="text-align:center">
    <img src="Example/Media/customStyleExample.gif">
</div>

## Navigation bar

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

## Examples

Follow these 3 steps to run Example project

- Clone PagerTabStripView repo.
- Open PagerTabStripView workspace.
- Run the _Example_ project.

## Installation

### CocoaPods

To install PagerTabStripView using CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'PagerTabStripView', '~> 2.0'
```

### Carthage

To install PagerTabStripView using Carthage, simply add the following line to your Cartfile:

```ruby
github "xmartlabs/PagerTabStripView" ~> 2.0
```

## Requirements

- iOS 14+
- Xcode 13.X

## Author

- [Xmartlabs SRL](https://github.com/xmartlabs) ([@xmartlabs](https://twitter.com/xmartlabs))

## Getting involved

- If you **want to contribute** please feel free to **submit pull requests**.
- If you **have a feature request** please **open an issue**.
- If you **found a bug** or **need help** please **check older issues and threads on [StackOverflow](http://stackoverflow.com/questions/tagged/PagerTabStripView) (Tag 'PagerTabStripView') before submitting an issue**.

Before contribute check the [CONTRIBUTING](https://github.com/xmartlabs/PagerTabStripView/blob/master/CONTRIBUTING.md) file for more info.

If you use **PagerTabStripView** in your app We would love to hear about it! Drop us a line on [Twitter](https://twitter.com/xmartlabs).
