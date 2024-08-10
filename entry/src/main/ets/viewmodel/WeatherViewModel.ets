import WeatherConstants from '../common/constants/WeatherConstants';
import http from '@ohos.net.http';
import geoLocationManager from '@ohos.geoLocationManager';
import { Location, LocationInfo, WeatherData, WeatherNowData, WeatherIndexData, DayForecast, FutureWeather } from '../common/model/Weather';
import ResponseResult from '../common/model/ResponseResult';


function lookUpCity(location: geoLocationManager.Location): Promise<WeatherData> {
  return new Promise(async (resolve: Function, reject: Function) => {
    let url = `https://geoapi.qweather.com/${WeatherConstants.CITY_LOOKUP}`;
    url += '?location=' + location.longitude + "," + location.latitude + '&key=' + WeatherConstants.KEY;
    console.error("url" + url)
    let httpRequest = http.createHttp();
    httpRequest.request(url, (err, data) => {
      if (!err) {
        console.info('Result:' + data.result);
        console.info('code:' + data.responseCode);
        console.info('header:' + JSON.stringify(data.header));
        console.info('cookies:' + data.cookies); // 8+
        let resultJson: WeatherData = JSON.parse(data.result as string);
        resolve(resultJson)
      } else {
        console.info('error:' + JSON.stringify(err));
        reject(err)
      }
    });
  });
}
export class AverageLocation {
  averageLongitude: number=0;
  averageLatitude: number=0;
}


function calculateAverageCoordinates(rectangle:string): AverageLocation {
  const coordinatesArray = rectangle.split(";").map(coord => coord.split(","));

  // 初始化经度和纬度的累加器
  let sumLongitude = 0;
  let sumLatitude = 0;

  // 计算经度和纬度的总和
  coordinatesArray.forEach(coord => {
    const longitude = coord[0];
    const latitude = coord[1];
    sumLongitude += parseFloat(longitude);
    sumLatitude += parseFloat(latitude);
  });

  // 计算平均值
  const averageLongitude = sumLongitude / coordinatesArray.length;
  const averageLatitude = sumLatitude / coordinatesArray.length;

  const average = new AverageLocation()
  average.averageLongitude = averageLongitude
  average.averageLatitude = averageLatitude
  return average
}

class WeatherViewModel {
  address: LocationInfo;

  constructor() {
    this.address = new LocationInfo();
  }

  getWeatherNow(location: LocationInfo): Promise<WeatherNowData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${WeatherConstants.SERVER}/${WeatherConstants.WEATHER_NOW}`;
      const result = calculateAverageCoordinates(location.rectangle);

      url += '?location=' + result.averageLongitude.toFixed(2) + "," + result.averageLatitude.toFixed(2) + '&key=' + WeatherConstants.KEY;
      console.error("url1" + url)
      let httpRequest = http.createHttp();
      httpRequest.request(url, (err, data) => {
        if (!err) {
          let now: WeatherNowData = JSON.parse(data.result as string)
          console.error("now", data.result)
          resolve(now)
        }
        else {
          reject(err)
        }
      });
    });
  }

  async queryTodayWeather() {
    try {
      const loc = await this.getCityFromIp();
      this.address = loc
      const weather = await this.getWeatherNow(loc);
      return weather.now;
    } catch (error) {
      console.error("Error:", error);
      throw new Error()
    }
  }

  getCityFromIp(): Promise<LocationInfo> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `https://restapi.amap.com/v3/ip?key=76959cfcdd1df58887071d9b6ce10bfa`;
      console.error("url" + url)
      let httpRequest = http.createHttp();
      httpRequest.request(url, (err, data) => {
        if (!err) {
          let resultJson: LocationInfo = JSON.parse(data.result as string);
          console.log("getCityFromIp:",resultJson.rectangle);

          resolve(resultJson)
        } else {
          reject(err)
          console.log("getCityFromIp:",err.message);

        }
      });
    })
  }

  getLifeIndex(): Promise<WeatherIndexData> {
    return new Promise(async (resolve: Function, reject: Function) => {

      if (this.address.infocode=="") {
        this.address = await this.getCityFromIp();
      }
      let location = this.address
      let url = `${WeatherConstants.SERVER}/${WeatherConstants.LIFE_INDEX}`;
      const result = calculateAverageCoordinates(location.rectangle);
      url += '?location=' + result.averageLongitude.toFixed(2) + "," + result.averageLatitude.toFixed(2) + '&type=1,2,3,4,5,8' + '&key=' + WeatherConstants.KEY;
      console.log("getLifeIndex" + url)
      let httpRequest = http.createHttp();

      httpRequest.request(url, { method: http.RequestMethod.GET, }, (err, data) => {
        if (!err) {
          // let life = new WeatherIndexData()
          // // Object.assign(life, JSON.parse(data.result as string));
          // merge(life, JSON.parse(data.result as string));
          console.log("getLifeIndex:", data.result);

          let life : WeatherIndexData =JSON.parse(data.result as string)

          resolve(life)
        } else {
          console.log("getLifeIndex:", err.message);

          reject(err)
        }
      });
    })
  }

  getHourWeather(): Promise<DayForecast> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${WeatherConstants.SERVER}/${WeatherConstants.HOUR_FORECAST}`;
      if (this.address.infocode == null) {
        this.address = await this.getCityFromIp();
      }
      let location = this.address
      const result = calculateAverageCoordinates(location.rectangle);

      url += '?location=' + result.averageLongitude.toFixed(2) + "," + result.averageLatitude.toFixed(2) + '&key=' + WeatherConstants.KEY;
      console.error("url1" + url)
      let httpRequest = http.createHttp();
      httpRequest.request(url, (err, data) => {
        if (!err) {
          // let day = new DayForecast()
          // assign(day, JSON.parse(data.result as string));
          let day : DayForecast = JSON.parse(data.result as string)
          console.log("getHourWeather:", day.code);

          resolve(day)
        }
        else {
          reject(err)
          console.log("getHourWeather:", err.message);

        }
      });
    });
  }

  getFutureForecast(): Promise<FutureWeather> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${WeatherConstants.SERVER}/${WeatherConstants.TENDAYS_FORECAST}`;
      if (this.address.infocode == null) {
        this.address = await this.getCityFromIp();
      }
      let location = this.address
      const result = calculateAverageCoordinates(location.rectangle);

      url += '?location=' + result.averageLongitude.toFixed(2) + "," + result.averageLatitude.toFixed(2) + '&key=' + WeatherConstants.KEY;
      console.error("url1" + url)
      let httpRequest = http.createHttp();
      httpRequest.request(url, (err, data) => {
        if (!err) {
          // let day = new FutureWeather()
          console.error("url1" + JSON.stringify(data.result))
          let day : FutureWeather =JSON.parse(data.result as string)
          if (day !instanceof FutureWeather) {
            day = JSON.parse(data.result as string)
          }
            // assign(day, JSON.parse(data.result as string));
          resolve(day)
        }
        else {
          reject(err)
        }
      });
    });
  }


}


let weatherViewModel = new WeatherViewModel();

export default weatherViewModel as WeatherViewModel;


