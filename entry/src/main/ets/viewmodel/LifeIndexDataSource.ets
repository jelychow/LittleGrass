import { BasicDataSource } from '../base/BaseDataSource';
import { DailyIndex } from '../common/model/Weather';
export  class LifeIndexDataSource extends BasicDataSource {
  private dataArray: Array<DailyIndex> = new Array();

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): DailyIndex {
    return this.dataArray[index];
  }

  public addData(index: number, data: DailyIndex): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public addAllData( datas: DailyIndex[]): void {
    this.dataArray.splice(0, this.dataArray.length, ...datas);
    this.notifyDataReload()
  }

  public pushData(data: DailyIndex): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
