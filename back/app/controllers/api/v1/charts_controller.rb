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
          bar: {chartdata: getBarChartdata(items, fromTo, format), legend: getBarLegend(getBarDatasets(items, fromTo, format))}, 
          pie: {chartdata: getPieChartdata(items), legend: getPieLegend(getPieDatasets(items))},
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
          bar: {chartdata: getBarChartdata(items, fromTo, format), legend: getBarLegend(getBarDatasets(items, fromTo, format))}, 
          pie: {chartdata: getPieChartdata(items), legend: getPieLegend(getPieDatasets(items))},
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
          bar: {chartdata: getBarChartdata(items, fromTo, format), legend: getBarLegend(getBarDatasets(items, fromTo, format))}, 
          pie: {chartdata: getPieChartdata(items), legend: getPieLegend(getPieDatasets(items))},
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
              id: item[1][0]["study_materials_id"],
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
          labels = items.keys
          datasets = getPieDatasets(items)
          chartdata = {labels: labels, datasets: datasets}
        end

        def getPieDatasets(items)
          datasets = [
            {
              id: [],
              label: [],
              backgroundColor: [],
              data: [],
            }
          ]

          items.each.each_with_index { |item, i| 
            datasets[0][:id].push(item[1][0]["study_materials_id"])
            datasets[0][:label].push(item[0])
            datasets[0][:backgroundColor].push(getColor(i))
            datasets[0][:data].push(item[1].sum{ |i| i["sum"].to_f})
          }

          datasets
        end

        def getPieLegend(datasets)
          total = datasets[0][:data].sum
          material_ids = datasets[0][:id]
          materials = StudyMaterial.with_attached_image.where(id: material_ids)

          legend = datasets[0][:id].map.with_index{ |id, i| 
            material = materials.find { |material| material.id == id }
            {
              image_url: material.image_url,
              color: datasets[0][:backgroundColor][i],
              title: datasets[0][:label][i],
              sum: datasets[0][:data][i],
              percentage: percentage = (datasets[0][:data][i]/total*100).round
            }
          }
        end

        def getBarLegend(datasets)
          material_ids = datasets.map do |dataset|
            dataset[:id]
          end
          
          materials = StudyMaterial.with_attached_image.where(id: material_ids)
          
          legend = datasets.map{ |dataset| 
            material = materials.find { |i| i.id == dataset[:id] }
            dataset[:id] = material.image_url
            dataset.transform_keys{ |k| 
              case k
              when :id 
                :image_url
              when :backgroundColor 
                :color
              when :label 
                :title
              else
                k
              end
            }
          }
        end

      
    end
  end
end