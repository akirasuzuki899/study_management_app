module Api
  module V1
    class TaskTemplateSerializer < ActiveModel::Serializer
      include TaskBase
      attributes :id, :user_id, :study_material_id, :name, :day_of_week, :start, :end, :prev_week_sunday_task, :color

      belongs_to :user
      belongs_to :study_material

      def prev_week_sunday_task
        if object.day_of_week == "日" then
          {
            id: object.id,
            user_id: object.user_id,
            study_material_id: object.study_material_id,
            name: object.name,
            day_of_week: object.day_of_week,
            start: prev_week_sunday_task_start,
            end: prev_week_sunday_task_end,
            color: object.color,
          }
        end
      end

      def prev_week_sunday_task_start
        I18n.l(Time.parse(self.start) - 7.days, format: :dateTime)
      end

      def prev_week_sunday_task_end
        I18n.l(Time.parse(self.end) - 7.days, format: :dateTime)
      end
      
    end
  end
end
