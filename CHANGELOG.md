# Change Log

All notable changes to PagerTabStrip will be documented in this file.

### [4.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/4.0.0)

<!-- Released on 2023-02-02. -->

- Xcode 14+, iOS 16+ now is required.
- Clean up code by using Swift 5.7 capabilities. 
- `.pagerTabItem(tag: SelectionType)` modifier now requires tag parameter which identifies the pager tab item. 
- `pagerTabStripViewStyle(_ style: PagerStyle)` is the new modifier to set up pager style. 
- Selection value, which indicates wich is the selected page, can be any Hashable value and not just an Int like it was in the previous version.
- Fix scroll behaivour when pager is added inside another pager or scrllable container. Whenever child page reatch its edges, parent scrollable container scrolls. Basically we added a parameter to disable edge scroll gesture so parent gesture is triggered. 
- Added several complex examples showing new functionality. 
- Scrollable style page now uses iOS 16 native layout engine through Layout protocol.
- Fixed inicator initial animation and position issue when presenting the page. 
- Fixed pages reording, adding, deleting. Now it works perfectly. 
- `public func onPageAppear(perform action: (() -> Void)?) -> some View` was removed. You should use onAppear native calback or useg selection state variable.
- Refactor enable disable swipe gesture. It's a Binding parameter from now. 
- `PagerTabViewDelegate` and `PagerTabViewState` deleted. Yu should use `selction` state or `pagerSettings.transition.progress(for: tag)` to get notification on selection and scroll progress changes. 


### [3.2.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.2.0)

<!-- Released on 2022-03-11. -->

- Add support for custom style

### [3.1.1](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.1.1)

<!-- Released on 2021-12-20. -->

- Fix swipe back gesture

### [3.1.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.1.0)

<!-- Released on 2021-12-09. -->

- Disable swipe gesture support
- Bug fixes

### [3.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.0.0)

<!-- Released on 2021-10-05. -->

- Add scrollable style
- Bug fixes

### [2.1.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/2.1.0)

<!-- Released on 2021-10-05. -->

- Support for Xcode 13
- Bug fixes

### [2.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/2.0.0)

<!-- Released on 2021-08-18. -->

- Add segmented and bar style
- Bug fixes

### [1.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/1.0.0)

<!-- Released on 2020-01-20. -->

- This is the initial version.

[xmartlabs]: https://xmartlabs.com
