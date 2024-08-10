export  * from "./http/retrofit/retrofit"

// library/src/main/ts/test.ets
export class Log {
  static info(msg: string) {
    console.info(msg);
  }
}

export  { testRetrofit } from './http/service/test'
