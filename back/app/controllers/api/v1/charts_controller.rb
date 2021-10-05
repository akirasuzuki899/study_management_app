module Api
  module V1
    class ChartsController < ApplicationController
      before_action :authenticate_user!

      def daily
        format = "daily"
        today = Date.today

        sql = <<-"EOS"
        SELECT 
          SUM(TIMESTAMPDIFF(SECOND, study_records.start_time, study_records.end_time)/60/60) AS sum, 
          `study_materials`.`id` AS study_materials_id, 
          `study_materials`.`title` AS study_materials_title, 
          DATE(`study_records`.`start_time`) AS date 
        FROM 
          `study_records`
        INNER JOIN 
          `study_materials` ON `study_materials`.`id` = `study_records`.`study_material_id` 
        WHERE 
          `study_records`.`user_id` = #{current_user.id}
          AND 
          `study_records`.`start_time` BETWEEN '#{(today-6).beginning_of_day}' AND '#{today.end_of_day}' 
        GROUP BY 
          `study_materials`.`id`, DATE(`study_records`.`start_time`)
        EOS

        items = ActiveRecord::Base.connection.select_all(sql).group_by{|i| i["study_materials_title"]}

        fromTo = (today-6..today).to_a

        render json: {
          bar_chartdata: getBarChartdata(items, fromTo, format), 
          pie_chartdata: getPieChartdata(items),
          material_info: materialInfo(items)
        }
      end

      def weekly
        format = "weekly"
        today = Date.today

        sql = <<-"EOS"
        SELECT 
          SUM(TIMESTAMPDIFF(SECOND, study_records.start_time, study_records.end_time)/60/60) AS sum, 
          `study_materials`.`id` AS study_materials_id, 
          `study_materials`.`title` AS study_materials_title, 
          WEEK(`study_records`.`start_time`, 3) AS week
        FROM 
          `study_records`
        INNER JOIN 
          `study_materials` ON `study_materials`.`id` = `study_records`.`study_material_id` 
        WHERE 
          `study_records`.`user_id` = #{current_user.id}
          AND 
          `study_records`.`start_time` BETWEEN '#{6.week.ago(today).monday.beginning_of_day}' AND '#{today.sunday.end_of_day}' 
        GROUP BY 
          `study_materials`.`id`, WEEK(`study_records`.`start_time`, 3)
        EOS

        items = ActiveRecord::Base.connection.select_all(sql).group_by{|i| i["study_materials_title"]}

        fromTo = (6.week.ago(today).monday..today.sunday).map { |i| i if i.wday == 1 }.compact

        render json: {
          bar_chartdata: getBarChartdata(items, fromTo, format), 
          pie_chartdata: getPieChartdata(items),
          material_info: materialInfo(items)
        }
      end

      def monthly
        format = "monthly"
        now = Time.now

        sql = <<-"EOS"
        SELECT 
          SUM(TIMESTAMPDIFF(SECOND, study_records.start_time, study_records.end_time)/60/60) AS sum, 
          `study_materials`.`id` AS study_materials_id, 
          `study_materials`.`title` AS study_materials_title, 
          MONTH(`study_records`.`start_time`) AS month
        FROM 
          `study_records`
        INNER JOIN 
          `study_materials` ON `study_materials`.`id` = `study_records`.`study_material_id` 
        WHERE 
          `study_records`.`user_id` = #{current_user.id}
          AND 
          `study_records`.`start_time` BETWEEN '#{6.month.ago(now).at_beginning_of_month}' AND '#{now.at_end_of_month}' 
        GROUP BY 
          `study_materials`.`id`, MONTH(`study_records`.`start_time`)
        EOS

        items = ActiveRecord::Base.connection.select_all(sql).group_by{|i| i["study_materials_title"]}

        fromTo = (6.month.ago(now).month..now.month).to_a

        render json: {
          bar_chartdata: getBarChartdata(items, fromTo, format), 
          pie_chartdata: getPieChartdata(items),
          material_info: materialInfo(items)
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

        def getBarChartdata(items, fromTo, format)
          labels = getBarLabels(fromTo, format)
          datasets = getBarDatasets(items, fromTo, format)

          chartdata = {labels: labels, datasets: datasets}
        end

        def getBarLabels(fromTo, format)
          labels = fromTo.to_a.map { |i|
            if    format == "daily" || format == "weekly" then
              i.strftime("%m/%d") 
            elsif format == "monthly" then
              "#{i}月"
            end
          }
        end

        def getBarDatasets(items, fromTo, format)

          datasets = items.map.with_index { |item, i| 
            {
              label: item[0], 
              backgroundColor:  getColor(i), 
              data: data = fromTo.map { |d|
                item[1].each.each_with_index {|data, i|

                  if    format == "daily" then
                    break data["sum"].to_f if data["date"] == d
                    break 0 if i == item[1].size - 1 

                  elsif format == "weekly" then
                    break data["sum"].to_f if data["week"] == d.cweek
                    break 0 if i == item[1].size - 1 

                  elsif format == "monthly" then
                    break data["sum"].to_f if data["month"] == d
                    break 0 if i == item[1].size - 1 
                  end
                }
              }
            }
          }
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
            data.push(item[1].sum { |hash| hash["sum"].to_f})
          end

          datasets = [{label: label, data: data, backgroundColor: backgroundColor}]
          chartdata = {labels: labels, datasets: datasets}
        end

        def materialInfo(items)
          materialInfo = []

          material_ids = items.map do |item|
            item[1][0]["study_materials_id"]
          end

          materials = StudyMaterial.where(id:  material_ids)

          urls = materials.map do |material|
            material.image_url
          end

          items.each.each_with_index do |item, i|
            materialInfo.push({title: item[0], image_url: urls[i], color: getColor(i)})
          end

          materialInfo
        end

      
    end
  end
end