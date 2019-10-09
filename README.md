# BottomHalfModal  ![Platform iOS11+](https://img.shields.io/badge/platform-ios11%2B-red) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

BottomHalfModal is a customizable half modal UI used in merpay.

![BottomHaflModal](https://github.com/mercari/BottomHalfModal/raw/master/Screenshots/basic.gif)

## Installation

### Carthage

```
github "mercari/BottomHalfModal"
```

### CocoaPods

```
pod "BottomHalfModal"
```


## Usage

BottomHalfModal can present any type of `UIVIewController` as content. The presented view controller needs to confirm to `SheetContentHeightModifiable` and define `sheetContentHeightToModify` that is the height of the half modal. Then call `adjustFrameToSheetContentHeightIfNeeded()` in `viewDidAppear`.

```swift
import BottomHalfModal

class XXXXViewController: SheetContentHeightModifiable {
    var sheetContentHeightToModify: CGFloat = 320
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustFrameToSheetContentHeightIfNeeded()
    }
}

```

Then, call `presentBottomHalfModal(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)` to show  the content.

```swift
    let vc = XXXXViewController()
    presentBottomHalfModal(vc, animated: true, completion: nil)
```

If you want to use `UINavigationController` in BottomHalfModal, use `BottomHalfModalNavigationController`. It handles content height update while push and pop navigations.

```swift
    let vc = XXXXViewController()
    let nav = BottomHalfNavigationController(rootViewController: vc)
    presentBottomHalfModal(nav, animated: true, completion: nil)
```


If you support multiple device orientation, please call `adjustFrameToSheetContentHeightIfNeeded()` in `viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)` too.

```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    adjustFrameToSheetContentHeightIfNeeded(with: coordinator)
}
```

## Demo

|Basic|
|---|
|![Basic](https://github.com/mercari/BottomHalfModal/raw/master/Screenshots/basic.gif)|

|TableView|
|---|
|![TableView](https://github.com/mercari/BottomHalfModal/raw/master/Screenshots/tableview.gif)|

|Navigation|
|---|
|![Navigation](https://github.com/mercari/BottomHalfModal/raw/master/Screenshots/navigation.gif)|

|StickyButton|
|---|
|![StickyButton](https://github.com/mercari/BottomHalfModal/raw/master/Screenshots/stickybutton.gif)|

|Input|
|---|
|![Input](https://github.com/mercari/BottomHalfModal/raw/master/Screenshots/input.gif)|

## Contribution

Please read the CLA carefully before submitting your contribution to Mercari.
Under any circumstances, by submitting your contribution, you are deemed to accept and agree to be bound by the terms and conditions of the CLA.

[https://www.mercari.com/cla/](https://www.mercari.com/cla/)


## License

Copyright 2019 Mercari, Inc.

Licensed under the MIT License.
