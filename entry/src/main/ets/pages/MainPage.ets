import { CommonConstants } from '../common/constants/CommonConstants';
import geoLocationManager from '@ohos.geoLocationManager';
import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import promptAction from '@ohos.promptAction'
import weatherViewModel from '../viewmodel/WeatherViewModel';
import router from '@ohos.router';
import util from '@ohos.util';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import {
  DailyForecast,
  DailyIndex,
  ForecastArray,
  FutureWeather,
  LocationInfo,
  WeatherIndexData,
  WeatherNow
} from '../common/model/Weather';
import shortcut from '@system.mediaquery'
import hilog from '@ohos.hilog';
import LifeIndex from '../view/LifeIndex';
import { LifeIndexDataSource } from '../viewmodel/LifeIndexDataSource';
import { HourForecastDataSource } from '../viewmodel/HourForecastDataSource';
import HourForecast from '../view/HourForecast';
import FutureForecast from '../view/FutureForecast';
import { Permission } from '../utils/PermissionHandler';
import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer } from '@kit.ArkTS';

/**
 * The MainPage that is routed as the SplashScreenPage.
 */
const permissions: Array<Permissions> = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];

@Entry
@Component
struct MainPage {
  @State weatherNow: WeatherNow = new WeatherNow()
  @State city: LocationInfo = new LocationInfo()
  @State lifeIndex: WeatherIndexData = new WeatherIndexData()
  @Provide indexs: Array<DailyIndex> = new Array()
  @State forecasts: FutureWeather = new FutureWeather()
  @State fc: ForecastArray = new ForecastArray()
  @Provide indexSource: LifeIndexDataSource = new LifeIndexDataSource();
  @Provide hourSource: HourForecastDataSource = new HourForecastDataSource();

  build() {
    // getCityInfo()
    Scroll() {
      Column() {
        Row() {
          Text(this.city.province + "," + this.city.city)
            .fontSize($r('app.float.title'))
            .fontColor(Color.White)
            .fontWeight(FontWeight.Regular)
          Image($r('app.media.ic_public_input_search'))
            .fillColor(Color.White)
            .width(vp2px(6))
            .height(vp2px(6))

        }.justifyContent(FlexAlign.SpaceBetween)
        .width(CommonConstants.MAIN_PAGE_COLUMN_WIDTH)
        .padding({ top: vp2px(20), left: vp2px(8), right: vp2px(8) })

        .onClick((e)=>{
          this.getGps()
        })

        Column() {
          Text(this.weatherNow.temp + "°")
            .fontSize($r('app.float.h1'))
            .fontColor(Color.White)
            .fontWeight(FontWeight.Regular)
            .baselineOffset(0)
          Row() {
            Text(this.weatherNow.text + " ")
              .fontSize($r('app.float.caption'))
              .fontColor(Color.White)
              .fontWeight(FontWeight.Regular)
              .baselineOffset(0)
              .margin({ top: vp2px(2), left: vp2px(3) })
            Text("体感 " + this.weatherNow.feelsLike + " °")
              .fontSize($r('app.float.caption'))
              .fontColor(Color.White)
              .fontWeight(FontWeight.Regular)
              .baselineOffset(0)
              .margin({ top: vp2px(2), left: vp2px(2) })
            Text(this.weatherNow.windDir + ' ' + this.weatherNow.windScale + ' 级')
              .fontSize($r('app.float.caption'))
              .fontColor(Color.White)
              .fontWeight(FontWeight.Regular)
              .baselineOffset(0)
              .margin({ top: vp2px(2), left: vp2px(2) })

          }.alignItems(VerticalAlign.Center)
        }.justifyContent(FlexAlign.SpaceBetween)
        .width(CommonConstants.MAIN_PAGE_COLUMN_WIDTH)
        .padding({ top: vp2px(10), left: vp2px(8), right: vp2px(8) })

        LifeIndex().margin({ top: 10 })
        HourForecast()
        ForEach(this.fc,(item:DailyForecast,index:number)=> {
            FutureForecast({ fcs: this.fc })
              .borderRadius(25)
              .backgroundColor('#661788c8')
              .margin({ left: 10, right: 10, top: 20 })
              .height(320)
            Row() {

            }.height(40)
          }, (item: DailyForecast, index: number): string => {
          return "";
        })


        // FutureForecast({fcs:this.fc})
        //   .borderRadius(25)
        //   .backgroundColor('#661788c8')
        //   .margin({ left: 10, right: 10, top: 20 })
        //   .height(300)
        // Row() {
        //
        // }.height(100)
      }

    }
    .scrollable(ScrollDirection.Vertical)
    .height('100%')
    .scrollBarColor(Color.Transparent)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
    .linearGradient({
      colors: [
        [0x1E90FF, 0], [0X87CEEB, 1.0]
      ]
    })
  }

  aboutToAppear() {
    router.clear()
    console.log("MainPage", "aboutToAppear")
    this.getCityInfo()
  }

  onPageShow() {
    console.log("MainPage", "onPageShow")
    this.getLifeIndex()
  }

  @Permission(permissions,getContext(this))
  getGps(){
    promptAction.showToast({message:'请求定位权限成功'})
  }

  handleCity() {
    this.city = weatherViewModel.address
    this.getHourWeather()
    this.getFutureForecast()
}

  getCityInfo() {
    let parent = this
    weatherViewModel.queryTodayWeather()
      .then(now => {
        parent.handleCity()
        console.log("getCityInfo", JSON.stringify(now));
        this.weatherNow = now
      })
  }

  getLifeIndex() {
    weatherViewModel
      .getLifeIndex()
      .then(life => {
        console.log("getLifeIndex1:", life);
        this.lifeIndex = life
        console.log("getLifeIndex:2", life.daily.length);
        this.indexSource.addAllData(life.daily)
      })
  }

  getHourWeather() {
    weatherViewModel
      .getHourWeather()
      .then(day => {
        console.log("getHourWeather",day.hourly)
        this.hourSource.addAllData(day.hourly)
      })
  }

  getFutureForecast() {
    weatherViewModel
      .getFutureForecast()
      .then(forecast => {
        if (forecast.daily==undefined) {
          this.getFakeData()
            .then((data) => {
              // 处理模拟的数据
              console.log(data);
              forecast = JSON.parse(data)
              this.fc.length = 0
              this.fc.push(...forecast.daily)
              console.error("forecasts:" + this.fc.length);
            })
            .catch((err: BusinessError) => {
            });

        }else {
          this.fc.length = 0
          this.fc.push(...forecast.daily)
          console.error("forecasts:" + this.fc.length);
        }

      })
  }

  getFakeData(): Promise<string> {
    return new Promise((resolve, reject) => {
      let context = getContext(this);
      context.resourceManager.getRawFileContent("tendaysForcast.json", (error: BusinessError, value: Uint8Array) => {
        if (error != null) {
          reject(error);
        } else {
          let textDecoderOptions: util.TextDecoderOptions = {
            ignoreBOM: true
          };
          let decodeWithStreamOptions: util.DecodeWithStreamOptions = {
            stream: false
          };
          let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
          let retStr = textDecoder.decodeWithStream(value, decodeWithStreamOptions);
          hilog.debug(10000, "getFakeData", retStr);
          resolve(retStr);
        }
      });
    });
  }

}

