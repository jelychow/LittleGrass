import { DailyIndex } from '../common/model/Weather';
import promptAction from '@ohos.promptAction'

@Component
export default struct LifeIndexItem {
  indexItem: DailyIndex = new DailyIndex();
  build() {
    Column() {
      Image(this.getImageByType(this.indexItem.type)).width(30).height(30).fillColor(Color.White)
      Text(this.indexItem.name).direction(Direction.Ltr).fontColor(Color.White)
      Text(this.indexItem.category).direction(Direction.Ltr).fontColor(Color.White)
    }.onClick(e => {
      promptAction.showToast({message:this.indexItem.text,bottom:200})
    })
    .justifyContent(FlexAlign.SpaceAround)
    .width('100%')
    .height(120)
    .borderRadius(15)
    .backgroundColor('#661788c8')
    .blur(1)

  }

  getImageByType(type: string): string {
    switch (type) {
      case '1':
        return 'weatherIcons/sport_index.svg'
      case '2':
        return 'weatherIcons/xiche_index.svg'
      case '3':
        return 'weatherIcons/chuanyi_index.svg'
      case '4':
        return 'weatherIcons/finish_index.svg'
      case '5':
        return 'weatherIcons/uv_index.svg'
      case '6':
        return 'weatherIcons/travel_index.svg'
      case '7':
        return 'weatherIcons/guomin_index.svg'
      case '8':
        return 'weatherIcons/cozy_index.svg'
      case '9':
        return 'weatherIcons/ganmao_index.svg'
      case '10':
        return 'weatherIcons/polution_index.svg'
      case '11':
        return 'weatherIcons/kongtiao_index.svg'
      case '12':
        return 'weatherIcons/sun_glass_index.svg'
      case '13':
        return 'weatherIcons/make_up_index.svg'
      case '14':
        return 'weatherIcons/liangshai_index.svg'
      case '15':
        return 'weatherIcons/jiaotong_index.svg'
      case '16':
        return 'weatherIcons/sun_screen_index.svg'
      default :
        return ''
    }
  }
}

