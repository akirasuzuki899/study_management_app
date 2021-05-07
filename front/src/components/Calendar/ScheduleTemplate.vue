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
            @click:event="showEvent"
          >
            <!-- <template v-slot:day-label-header="{ day }">{{day = ""}}</template> -->
          </v-calendar>

          <v-menu
            v-model="selectedOpen"
            :close-on-content-click="false"
            :activator="selectedElement"
            offset-x
          >
            <v-card
              color="grey lighten-4"
              min-width="350px"
              flat
            >
              <v-toolbar
                :color="selectedEvent.color"
                dark
              >
                <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
                <v-spacer></v-spacer>
                <v-btn icon @click.stop="setDefaultFormValue(); dialog = true">
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
              </v-toolbar>
              <v-card-text>
                <p v-html="selectedEvent.start_time_hm"></p>
                <p v-html="selectedEvent.end_time_hm"></p>
              </v-card-text>
              <v-card-actions>
                <v-btn
                  text
                  color="secondary"
                  @click="selectedOpen = false"
                >
                  Cancel
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-menu>

          <!-- ダイアログ -->
          <div class="text-center" :key="selectedEvent.id">
            <v-dialog
              v-model="dialog"
              width="500"
            >
              <v-card>
                <v-card-title>
                  <span class="headline">{{selectedEvent.name}}</span>
                </v-card-title>
                <v-card-text>
                  <v-container>
                    <!-- <form @submit.prevent="createSchedule"> -->
                    <v-row>
                      <v-col
                        cols="12"
                        sm="12"
                        md="4"
                      >
                        <v-text-field
                          label="タイトル"
                          :value="selectedEvent.name"
                          required
                        ></v-text-field>
                      </v-col>
                      <v-col
                        cols="12"
                        sm="12"
                        md="4"
                      >
                        <v-select 
                          label="教材"
                          :items="studyMaterials"
                          item-text="title"
                          item-value="id"
                          :value="selectedEvent.study_material_id"
                        />
                      </v-col>
                      <v-col
                        cols="12"
                        sm="12"
                        md="4"
                      >
                        <v-select
                          label="曜日"
                          :items="dayOfWeek" 
                          :value="selectedEvent.day_of_week"
                          required
                        ></v-select>
                      </v-col>

                      <!-- タイムピッカー -->
                      <!-- 開始時間 -->
                      <v-col
                        cols="12"
                        sm="6"
                        md="6"
                      >
                        <v-menu
                          ref="menu"
                          v-model="timePickerStart"
                          :close-on-content-click="false"
                          :nudge-right="40"
                          :return-value.sync="formData.start_time"
                          transition="scale-transition"
                          offset-y
                          max-width="290px"
                          min-width="290px"
                        >
                          <template v-slot:activator="{ on, attrs }">
                            <v-text-field
                              v-model="formData.start_time"
                              label="開始時刻"
                              prepend-icon="mdi-clock-time-four-outline"
                              readonly
                              v-bind="attrs"
                              v-on="on"
                            ></v-text-field>
                          </template>
                          <v-time-picker
                            v-if="timePickerStart"
                            v-model="formData.start_time"
                            full-width
                            @click:minute="$refs.menu.save(formData.start_time)"
                          ></v-time-picker>
                        </v-menu>
                      </v-col>

                      <!-- 終了時間 -->
                      <v-col
                        cols="12"
                        sm="6"
                        md="6"
                      >
                        <v-menu
                          ref="menu"
                          v-model="timePickerEnd"
                          :close-on-content-click="false"
                          :nudge-right="40"
                          :return-value.sync="formData.end_time"
                          transition="scale-transition"
                          offset-y
                          max-width="290px"
                          min-width="290px"
                        >
                          <template v-slot:activator="{ on, attrs }">
                            <v-text-field
                              v-model="formData.end_time"
                              label="終了時刻"
                              prepend-icon="mdi-clock-time-four-outline"
                              readonly
                              v-bind="attrs"
                              v-on="on"
                            ></v-text-field>
                          </template>
                          <v-time-picker
                            v-if="timePickerEnd"
                            v-model="formData.end_time"
                            full-width
                            @click:minute="$refs.menu.save(formData.end_time)"
                          ></v-time-picker>
                        </v-menu>
                      </v-col>
                      <!-- タイムピッカー -->

                    </v-row>
                  </v-container>
                  <small>*indicates required field</small>
                </v-card-text>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click.stop="dialog = false"
                  >
                    取消
                  </v-btn>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click.stop="dialog = false"
                  >
                    保存
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </div>
          <!-- ダイアログ -->

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
      dayOfWeek: ['月', '火', '水', '木', '金', '土', '日'],
      timePickerStart: false,
      timePickerEnd: false,
      dialog: false,
      selectedEvent: {},
      selectedElement: null,
      selectedOpen: false,
      schedules: [],
      studyMaterials: [],
      study_material_id: '',
      formData: {
        name: '',
        study_material_id: '',
        day_of_week: '',
        start_time: '',
        end_time: ''
      }
    }),
    methods: {
      showEvent ({ nativeEvent, event }) {
        const open = () => {
          this.selectedEvent = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.selectedOpen = true))
        }

        if (this.selectedOpen) {
          this.selectedOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }

        nativeEvent.stopPropagation()
      },
      setDefaultFormValue () {
        this.formData.name = this.selectedEvent.name
        this.formData.study_material_id = this.selectedEvent.study_material_id
        this.formData.day_of_week = this.selectedEvent.day_of_week
        this.formData.start_time = this.selectedEvent.start_time_hm
        this.formData.end_time = this.selectedEvent.end_time_hm

        console.log("setDefaultFormValue")
        console.log(this.formData.start_time)
      },
    },
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
          this.schedules.push(...data.data.schedule_templates)
          this.studyMaterials.push(...data.data.study_materials)
          console.log(data)
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