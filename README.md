# Snap

A Ruby sandbox inspired by Logo and Scratch.

See the [first demo on YouTube](https://youtu.be/RmqDCCKt7sc).

## Useful links

* Java/Eclipse SWT Documentation
** [Graphics Package](https://javadoc.scijava.org/Eclipse/org/eclipse/swt/graphics/package-summary.html)
** [Canvas](https://help.eclipse.org/2020-12/index.jsp?topic=/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/Canvas.html)
** [GC](https://www.eclipse.org/articles/Article-SWT-graphics/SWT_graphics.html)
** [Images](https://www.eclipse.org/articles/Article-SWT-images/graphics-resources.html)
** [Transform](http://download.eclipse.org/rt/rap/doc/3.1/guide/reference/api/org/eclipse/swt/graphics/Transform.html)
** [SWT source](https://github.com/eclipse/eclipse.platform.swt)

## Notes

### Convert a .mov into a .gif and try optimize

``` bash
ffmpeg -i 21-01-24_snap_demo.mov -pix_fmt rgb24 -r 24 -s 1440x900 snap_demo1.gif
convert -layers Optimize snap_demo1.gif snap_demo1o.gif
```

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
