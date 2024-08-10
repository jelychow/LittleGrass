export class Location {
  name: string = "";
  id: string = "";
  lat: string = "";
  lon: string = "";
  adm2: string = "";
  adm1: string = "";
  country: string = "";
  tz: string = "";
  utcOffset: string = "";
  isDst: string = "";
  type: string = "";
  rank: string = "";
  fxLink: string = "";
}

export class WeatherData {
  code: string = "";
  location: Location[] = [];
}

// from gaode map
export class LocationInfo {
  status: string = "";
  info: string = "";
  infocode: string = "";
  province: string = '';
  city: string = '';
  adcode: string = "";
  rectangle: string = "";
}

export class WeatherNowData {
  code: string = "";
  updateTime: string = "";
  fxLink: string = "";
  now: WeatherNow = new WeatherNow();
}

export class WeatherNow {
  obsTime: string = "";
  temp: string = '';
  feelsLike: string = "";
  icon: string = '101';
  text: string = '';
  wind360: string = "";
  windDir: string = '';
  windScale: string = '';
  windSpeed: string = '';
  humidity: string = "";
  precip: string = "";
  pressure: string = "";
  vis: string = "";
  cloud: string = "";
  dew: string = "";
}

export class DailyIndex {
  date: string = '';
  type: string = '';
  name: string = '';
  level: string = '';
  category: string = '';
  text: string = '';
}


export class WeatherIndexData {
  code?: string;
  updateTime?: string;
  fxLink?: string;
  daily: DailyIndex[]=[];
}


export class HourlyData {
  fxTime: string = "";
  temp: string = "";
  icon: string = "";
  text: string = "";
  wind360: string = "";
  windDir: string = "";
  windScale: string = "";
  windSpeed: string = "";
  humidity: string = "";
  precip: string = "";
  pressure: string = "";
  cloud: string = "";
  dew: string = "";
}

export class DayForecast {
  code: string = "";
  updateTime: string = "";
  fxLink: string = "";
  hourly: HourlyData[] = [];
}

@Observed
export class DailyForecast {
  fxDate: string = "";
  sunrise: string = "";
  sunset: string = "";
  moonrise: string = "";
  moonset: string = "";
  moonPhase: string = "";
  moonPhaseIcon: string = "";
  tempMax: string = "";
  tempMin: string = "";
  iconDay: string = "";
  textDay: string = "";
  iconNight: string = "";
  textNight: string = "";
  wind360Day: string = "";
  windDirDay: string = "";
  windScaleDay: string = "";
  windSpeedDay: string = "";
  wind360Night: string = "";
  windDirNight: string = "";
  windScaleNight: string = "";
  windSpeedNight: string = "";
  humidity: string = "";
  precip: string = "";
  pressure: string = "";
  vis: string = "";
  cloud: string = "";
  uvIndex: string = "";

  constructor() {

  }
}

@Observed
export class ForecastArray extends Array<DailyForecast> {
}

@Observed
export class FutureWeather {
  constructor() {

  }

  code: string = "";
  updateTime: string = "";
  fxLink: string = "";
  daily: DailyForecast[] = [];
}