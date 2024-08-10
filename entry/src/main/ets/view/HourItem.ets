import { HourlyData } from '../common/model/Weather';


@Component
export default struct HourItem{
  hourItem: HourlyData = new HourlyData();

  build(){
    Column(){
      Text( this.getTimeFromDate(this.hourItem.fxTime)).fontColor(Color.White)
      Image('weatherIcons/'+ this.hourItem.icon+'.svg').width(30).height(30).fillColor(Color.White)
      Text(this.hourItem.temp+'°').direction(Direction.Ltr).fontColor(Color.White)
    }.height(100).width(100).justifyContent(FlexAlign.SpaceAround).margin({top:12})
  }

  getTimeFromDate(d:string){
    const datetimeObj = new Date(d);
    const timeStr = datetimeObj.toISOString().slice(11, 16);
    return timeStr
  }
}