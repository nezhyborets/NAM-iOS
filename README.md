# NAM-iOS
Nezhyborets Alexei Mihalylovich helpers

# ContentInsetHackTableView
When you want some part of table view to be initially hidden, so that you can pull to reveal it later (see example below) - there is a problem that your table view might have not enough content size to scroll. 

Simply set `additionalHeaderHeight` on instance of `ContentInsetHackTableView` and you'll be able to scroll more with less `contentSize`.
Hacking this stuff with `contentInset` seems to be the most native approach to such a task. There is also `ContentSizeHackTableView` variant, which resizes content size each time `contentSize` is set, but it's more buggy.

![2014-10-22 11_35_09](https://thumbs.gfycat.com/WideeyedGrippingAmericankestrel-size_restricted.gif)
