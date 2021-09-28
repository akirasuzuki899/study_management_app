module Api
  module V1
    class ChartsController < ApplicationController
      before_action :authenticate_user!

      def weekly
        today = Date.today

        sql = <<-"EOS"
        SELECT 
          SUM(TIMESTAMPDIFF(SECOND, study_records.start_time, study_records.end_time)/60/60) AS sum, 
          `study_materials`.`title` AS study_materials_title, 
          DATE(`study_records`.`start_time`) AS start_date 
        FROM 
          `study_records`
        INNER JOIN 
          `study_materials` ON `study_materials`.`id` = `study_records`.`study_material_id` 
        WHERE 
          `study_records`.`user_id` = #{current_user.id}
          AND 
          `study_records`.`start_time` BETWEEN '#{(today-6).beginning_of_day}' AND '#{today.end_of_day}' 
        GROUP BY 
          `study_materials`.`title`, DATE(`study_records`.`start_time`)
        EOS

        items = ActiveRecord::Base.connection.select_all(sql).group_by{|i| i["study_materials_title"]}

        render json: {
          bar_chartdata: getBarChartdata(items, today-6, today), 
          pie_chartdata: getPieChartdata(items)
        }
      end
      
      private

      def getColor(index)
        colors = [
          '#86A446','#B99135','#2863A6','#A64431',
          '#7C5A29','#913D98','#988F5C','#5C92B3',
          '#C26F93','#5F5F5F','#3A7942','#AA5726',
          '#534792','#4D9DAE','#D8CB4C']

        colors[index % colors.size]
      end

      def getBarChartdata(items, from, to)
        labels = (from.strftime("%m/%d")..to.strftime("%m/%d")).to_a
        datasets = []

        items.each.each_with_index do |item, i|
          label = item[0]
          backgroundColor = getColor(i)
          data = (from..to).map { |day|
            item[1].each.each_with_index {|data, i| 
              break data["sum"] if data["start_date"] == day
              break "0" if i == item[1].size - 1 
            }
          }
          datasets.push({label: label, data: data, backgroundColor: backgroundColor})
        end

        chartdata = {labels: labels, datasets: datasets}
      end

      def getPieChartdata(items)
        labels = []
        label = []
        datasets = []
        data = []
        backgroundColor = []

        items.each.each_with_index do |item, i|
          labels.push(item[0])
          label.push(item[0])
          backgroundColor.push(getColor(i))
          data.push(item[1].sum { |hash| hash["sum"]})
        end

        datasets = [{label: label, data: data, backgroundColor: backgroundColor}]
        chartdata = {labels: labels, datasets: datasets}
      end
      
    end
  end
end