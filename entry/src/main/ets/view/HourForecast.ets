import {  HourlyData } from '../common/model/Weather';
import { HourForecastDataSource } from '../viewmodel/HourForecastDataSource';
import HourItem from './HourItem';
@Component
export default struct HourForecast {
  @Consume hourSource: HourForecastDataSource;

  build() {
    List() {
      LazyForEach(this.hourSource, (item: HourlyData, index: number) => {
        ListItem() {
          HourItem({hourItem:item})
        }
        .onClick(() => {

        })
      }, (item: string) => item)
    }.cachedCount(5).listDirection(Axis.Horizontal).direction(Direction.Ltr)
    .height(120).borderRadius(25)
    .backgroundColor('#661788c8')
    .margin({left:10,right:10,top:20})
  }

}