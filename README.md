## IOS手游变速器 - GameGear

IOS端免越狱手游变速器，支持主流游戏引擎开发的游戏，包括H5游戏。支持大部份真机和模拟器，为玩家提供稳定流畅的游戏加速/减速体验。

本项目是接入变速器SDK的示例性Demo，演示了如何使用SDK提供的接口，轻松实现游戏的加速/减速。

**注意：项目中的SDK版本是beta版，仅适用于Demo，如需正式版，请联系我们获取。**

**微信：bluesky221010**

## SDK接入指引

### 1. SDK配置

将GearSdk.framework拷贝到项目目录下，选中项目的Target，转到General，在Frameworks,Libraries,and Embedded Content中添加GearSdk.framework引用，Embed方式设置为Embed & Sign。

### 2. 同意隐私协议

在用户同意隐私协议后，调用如下api同意隐私协议。注意：此api非常重要，若您没有隐私协议需求，也需要在合适的时机调用此api同意隐私协议，例如在AppDelegate的didFinishLaunchingWithOptions中，否则将导致SDK无法正常使用。

```object-c
[GearSDK setAgreePrivacy:YES];
```

### 3. 使用内置UI

若您没有自定义变速器UI的需求，则可以使用我们SDK内置的控制面板。

#### 显示悬浮球

```object-c
[GearSDK showGearView];
```

如果需要设置悬浮球初始位置，可以调用这个api：

```object-c
[GearSDK showGearViewxPos:x yPos:y];
```

#### 隐藏悬浮球

```object-c
[GearSDK hideGearView];
```

### 4. 自定义UI

若您需要自定义变速器UI，则可以调用以下api实现对游戏的速度控制。

#### 配置速度档位

调用如下api可配置变速器的速度档位和游戏最大倍速：

```object-c
[GearSDK configMaxSpeedIndex:maxSpeedIndex maxGear:maxGear];
```

maxSpeedIndex：最大速度档位，默认为10。

maxGear：最大倍速，即游戏的真实倍速，默认为5。

#### 设置加速模式下的速度档位

调用如下api可设置加速模式下的速度档位，最小速度档位为1，最大速度档位为maxSpeedIndex，默认为10。速度档位值越大，游戏速度越快，最快为maxGear，默认为5倍速。

```object-c
[GearSDK speedUp:speedIndex];
```

#### 设置减速模式下的速度档位

调用如下api可设置减速模式下的速度档位，最小速度档位为1，最大速度档位为maxSpeedIndex，默认为10。速度档位值越大，游戏速度越慢，最慢为1/maxGear，默认为1/5倍速。

```object-c
[GearSDK speedDown:speedIndex];
```

#### 开始变速

调用如下api可开启游戏变速。

```object-c
[GearSDK start];
```

#### 停止变速

调用如下api可停止游戏变速。

```object-c
[GearSDK stop];
```

## 变速效果
[点击查看效果图](https://github.com/youtoolx/GameGear4IOS/tree/main/doc/speed.gif)

## 致谢
[Dobby](https://github.com/jmpews/Dobby): [Apache License 2.0](https://github.com/jmpews/Dobby/blob/master/LICENSE)