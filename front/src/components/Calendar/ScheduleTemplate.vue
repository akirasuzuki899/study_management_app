<template>
  <v-app>
    <v-row>
      <v-col>
        <v-sheet height="900">
          <v-calendar
            ref="calendar"
            :value="baseDate"
            :events="schedules"
            color="primary"
            type="week"
            :weekdays="[1, 2, 3, 4, 5, 6, 0]"
          >
            <!-- <template v-slot:day-label-header="{ day }">{{day = ""}}</template> -->
          </v-calendar>
        </v-sheet>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
import axios from "axios";

  export default {
    data: () => ({
      baseDate: '2000-01-03',
      schedules: [
        {name: "test",
        start: '2000-01-04 10:00:00',
        end: '2000-01-04 12:00:00',

        }
      ],
    }),
    mounted () {
      this.$refs.calendar.scrollToTime('08:00')
    },
    computed: {
      authTokens() {
        return this.$store.getters.authTokens;
      }
    },
    created() {
      axios
        .get('/api/v1/schedule_templates', {
          headers: this.authTokens
        })
        .then(({data}) => {
          this.schedules.push(...data.data)
        });
    }
  }
</script>

<style scoped>
.my-event {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  border-radius: 2px;
  background-color: #1867c0;
  color: #ffffff;
  border: 1px solid #1867c0;
  font-size: 12px;
  padding: 3px;
  cursor: pointer;
  margin-bottom: 1px;
  left: 4px;
  margin-right: 8px;
  position: relative;
}

.my-event.with-time {
  position: absolute;
  right: 4px;
  margin-right: 0px;
}
</style>