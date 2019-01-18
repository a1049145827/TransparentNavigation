# TransparentNavigation
iOS Transparent NavigationBar

## Features

- [x] Transparency changes during page switching
- [x] Navigation Bar Transparency Change When ScrollView Slides
- [x] Fluent switching when the gesture slides back
- [x] System adaptation for iOS8+

## Example

![example](https://github.com/a1049145827/TransparentNavigation/raw/master/TransparentNavigation.gif)

## Installation

cocoapods:

```
pod 'TransparentNavigation'
```

## Usage

set the alpha in viewController's function: `-viewWillAppear:` likes the demo

```objc
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBarBgAlpha = @1;
}
```



## Reference article:

[如何优雅地在Swift4中实现Method Swizzling](http://blog.yaoli.site/post/%E5%A6%82%E4%BD%95%E4%BC%98%E9%9B%85%E5%9C%B0%E5%9C%A8Swift4%E4%B8%AD%E5%AE%9E%E7%8E%B0Method-Swizzling)

