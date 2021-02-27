# Snap

A Ruby sandbox inspired by Logo and Scratch.

See the [first demo on YouTube](https://youtu.be/RmqDCCKt7sc).

## Useful links

* Java/Eclipse SWT Documentation
  * [Widgets Package](https://javadoc.scijava.org/Eclipse/org/eclipse/swt/widgets/package-summary.html)
  * [Graphics Package](https://javadoc.scijava.org/Eclipse/org/eclipse/swt/graphics/package-summary.html)
  * [Layouts Package](https://javadoc.scijava.org/Eclipse/org/eclipse/swt/layout/package-summary.html)
  * [Custom Widgets](https://javadoc.scijava.org/Eclipse/org/eclipse/swt/custom/package-summary.html) - SashForm, CTabFolder and such
  * [SWT source](https://github.com/eclipse/eclipse.platform.swt)

## Notes

### Convert a .mov into a .gif and try optimize

``` bash
ffmpeg -i 21-01-24_snap_demo.mov -pix_fmt rgb24 -r 24 -s 1440x900 snap_demo1.gif
convert -layers Optimize snap_demo1.gif snap_demo1o.gif
```

### Building Windows

[VirtualBox](https://www.virtualbox.org/wiki/Downloads)
[Windows VMs](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/)
[Edge](https://www.microsoft.com/en-us/edge)
[OpenJDK](https://adoptopenjdk.net)
[JRuby](https://www.jruby.org/download)
[Git](https://git-scm.com/downloads)


## Contributing

* Check out the latest master to make sure the feature hasn't been
    implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't
    requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it
    in a future version unintentionally.


## Copyright

Copyright (c) 2021 Marc Heiligers. See LICENSE.txt for further details.
