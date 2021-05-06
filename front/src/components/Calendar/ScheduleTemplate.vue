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
                <v-btn icon @click.stop="dialog = true">
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
              </v-toolbar>
              <v-card-text>
                <p v-html="selectedEvent.start"></p>
                <p v-html="selectedEvent.end"></p>
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
          <div class="text-center">
            <v-dialog
              v-model="dialog"
              width="500"
            >
              <v-card>
                <v-card-title>
                  <span class="headline">{{this.selectedEvent.name}}</span>
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
                          :value="this.selectedEvent.name"
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
                          :value="this.selectedEvent.study_material_id"
                        />
                      </v-col>
                      <v-col
                        cols="12"
                        sm="12"
                        md="4"
                      >
                        <v-text-field
                          label="予定"

                          required
                        ></v-text-field>
                      </v-col>
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
      dialog: false,
      selectedEvent: {},
      selectedElement: null,
      selectedOpen: false,
      schedules: [],
      studyMaterials: [],
      study_material_id: ''
    }),
    methods: {
      showEvent ({ nativeEvent, event }) {
        const open = () => {
          this.selectedEvent = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.selectedOpen = true))
          console.log(this.selectedEvent);
        }

        if (this.selectedOpen) {
          this.selectedOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }

        nativeEvent.stopPropagation()
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
          console.log(this.schedules);
          console.log(this.studyMaterials)
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