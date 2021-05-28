const minTime = {
  params: ["startTime", "min"],
  validate: ( endTime, { startTime, min }) => {
    const tmp_date = '2000/01/03'
    const start = new Date(`${tmp_date} ${startTime}`)
    const end = new Date(`${tmp_date} ${endTime}`)

    if ( !startTime ) return true;

    if ( start.getTime() > end.getTime()) {
      const totalTime = end.setDate(end.getDate() + 1) - start
      return ( totalTime >= min*60*1000 ? true : false )

    } else if ( start.getTime() < end.getTime()) {
      const totalTime = end - start
      return ( totalTime >= min*60*1000 ? true : false )

    } else {
      return true
    }
  },
  message: "合計時間は15分以上にしてください"
};

export { minTime }