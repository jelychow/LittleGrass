import { BasicDataSource } from '../base/BaseDataSource';
import {  HourlyData } from '../common/model/Weather';
export  class HourForecastDataSource extends BasicDataSource {
  private dataArray: Array<HourlyData> = new Array();

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): HourlyData {
    return this.dataArray[index];
  }

  public addData(index: number, data: HourlyData): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public addAllData( datas: HourlyData[]): void {
    this.dataArray.splice(0, this.dataArray.length, ...datas);
    this.notifyDataReload()
  }

  public pushData(data: HourlyData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
