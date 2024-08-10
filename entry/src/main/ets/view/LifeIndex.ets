import { DailyIndex } from '../common/model/Weather';
import { LifeIndexDataSource } from '../viewmodel/LifeIndexDataSource';
import LifeIndexItem from './LifeIndexItem';
@Component
export default struct LifeIndex {
  @Consume indexSource: LifeIndexDataSource;

  build() {
    Grid() {
      LazyForEach(this.indexSource, (item: DailyIndex, index: number) => {
        GridItem() {
          LifeIndexItem({indexItem:item})
        }
        .onClick(() => {

        })
      }, (item: string) => item)
    }.cachedCount(5)
    .height(260)
    .margin({left:10,right:10,top:20})
    .rowsTemplate('1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
    .columnsTemplate('1fr 1fr 1fr')
  }

}