import moment from 'moment'

const minTime = {
  params: ["startTime", "min"],
  validate: ( endTime, { startTime, min }) => {

    if ( !startTime ) return true;

    const start_time = moment(startTime, 'HH:mm')
    const end_time = moment(endTime, 'HH:mm')

    const totalTime = start_time >=  end_time
      ? end_time.add(1, 'd') - start_time
      : end_time - start_time
    return totalTime >= min*60*1000 ? true : false

  },
  message: "合計時間は15分以上にしてください"
};


export { minTime }