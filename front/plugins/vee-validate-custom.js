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

const url = {
  validate(value) {
    var pattern = new RegExp('^(https?:\\/\\/)?' + // protocol
      '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|' + // domain name
      '((\\d{1,3}\\.){3}\\d{1,3}))' + // OR ip (v4) address
      '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*' + // port and path
      '(\\?[;&a-z\\d%_.~+=-]*)?' + // query string
      '(\\#[-a-z\\d_]*)?$', 'i'); // fragment locator
    return pattern.test(value);
  },
  message: 'URLを入力してください'

};



export { minTime, url }