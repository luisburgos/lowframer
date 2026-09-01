# Changelog

## [0.3.0](https://github.com/luisburgos/lowframer/compare/0.2.0...0.3.0) (2026-09-01)

`LowframerWindow` was hardcoded to 160×120 and took no size argument, so every
composition was landscape. It now takes a `size`, with `LowframerSizes` holding
the shapes that come up:

```dart
LowframerWindow(size: LowframerSizes.mobile, child: art)
LowframerCover(windowSize: LowframerSizes.mobile, child: art)
```

`LowframerCover` takes the same value and derives its panel height from it, so
a cover and the window it holds cannot disagree. Both default to
`LowframerSizes.desktop`, which is the previous fixed shape — nothing existing
changes.


### Features

* **example:** add a Library tab of per-primitive playgrounds ([#10](https://github.com/luisburgos/lowframer/issues/10)) ([2602628](https://github.com/luisburgos/lowframer/commit/2602628e2e2e53a44602f13c1b977b8f17c1d53d))
* give the window a frame ([69afb73](https://github.com/luisburgos/lowframer/commit/69afb730baa3f195b5aa40089e02fd352ec6e3fc))
* **showcase:** add two examples and reorder the tab ([#17](https://github.com/luisburgos/lowframer/issues/17)) ([becdad7](https://github.com/luisburgos/lowframer/commit/becdad7b6bf104b94bf7605e3d8bf0f79f5eefd0)), closes [#18](https://github.com/luisburgos/lowframer/issues/18)
* **showcase:** move the seed color into the app bar ([#15](https://github.com/luisburgos/lowframer/issues/15)) ([1320c14](https://github.com/luisburgos/lowframer/commit/1320c1483331d8c9ba1dcd801804b62e4b02d555))

### Bug Fixes

* **showcase:** centre the window when the cover is off ([f8a22e7](https://github.com/luisburgos/lowframer/commit/f8a22e723f6e022918edc57847f531b9ff01d09c))
* **showcase:** correct the stale web app title ([#14](https://github.com/luisburgos/lowframer/issues/14)) ([473b5d0](https://github.com/luisburgos/lowframer/commit/473b5d0f9387433b2b37bd0a233352815362ae23))
* **showcase:** size the arts by proportion, not by the desktop frame ([cc8874e](https://github.com/luisburgos/lowframer/commit/cc8874e002f8add13806e57b1f90b44e6a08a0fe))

### Build & Dependencies

* **example:** bump playgrounder to 0.3.0 ([#11](https://github.com/luisburgos/lowframer/issues/11)) ([2ea731c](https://github.com/luisburgos/lowframer/commit/2ea731c7008c575981df9715cdffc9f3b1a440cd))
* **example:** bump playgrounder to 0.3.1 ([#12](https://github.com/luisburgos/lowframer/issues/12)) ([6e65e69](https://github.com/luisburgos/lowframer/commit/6e65e69990698d8085c3c45d7c4451078b53002e))

### Refactors

* **showcase:** rename the palette example to Theming and flatten it ([#16](https://github.com/luisburgos/lowframer/issues/16)) ([c79ae7c](https://github.com/luisburgos/lowframer/commit/c79ae7c5ff3fea0e2ed59c1387a092642e1e3986))
* **showcase:** show one subject, and name the page for its widgets ([f660d38](https://github.com/luisburgos/lowframer/commit/f660d381014bf02543227c7ddee038927bd28d41))
* split the demo into a thin example and a showcase ([#13](https://github.com/luisburgos/lowframer/issues/13)) ([7a940b1](https://github.com/luisburgos/lowframer/commit/7a940b1a2ea81098c8e8c54bf32bda4909d1cb7f))
# Changelog

## [0.2.0](https://github.com/luisburgos/lowframer/compare/0.1.0...0.2.0) (2026-08-25)

### Features

* **example:** show the seed colors inline in the inspector footer ([#8](https://github.com/luisburgos/lowframer/issues/8)) ([b1926e4](https://github.com/luisburgos/lowframer/commit/b1926e45d5278ea8abb9c3a1d82d3cdd44900c93))

### Chores

* **deps:** bump actions/deploy-pages from 4 to 5 ([#7](https://github.com/luisburgos/lowframer/issues/7)) ([5e34c01](https://github.com/luisburgos/lowframer/commit/5e34c01b8e71acb5698cd8d9ea904814dc419c7c))
* **deps:** bump actions/upload-pages-artifact from 3 to 5 ([#6](https://github.com/luisburgos/lowframer/issues/6)) ([8ced8f0](https://github.com/luisburgos/lowframer/commit/8ced8f07e1c844d6505e0601d056fc6292f169f8))

## 0.1.0 (2026-08-24)

Initial release: `LowframerPalette`, `LowframerWindow`, `LowframerCover`,
`LowframerBox` (with `.line` and `.pill`), and `LowframerScribble` with its
`wave` and `sketch` styles.
