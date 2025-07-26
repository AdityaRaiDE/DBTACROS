
/*
-- -> convert a column to lowercase and uppaercase and INITICAP based on arguments
-- -> Write a macro that converts a column to given case.
-- -> Write a macro that converts a string to title case (capitalize first letter).

*/
{% macro covert_case(function_name,column_name)  %}
    {% if function_name | upper in ['UPPER','LOWER','INITCAP']%}
        {{ function_name~'('~column_name~')' }}
    {% else %}
       {% do exceptions.raise_compiler_error("Invalid Case Convertion function ") %}
    {% endif %}
{% endmacro %}



Write a macro to trim whitespaces from both ends of a string column.

Write a macro that returns today’s date.
Use: current_date

Write a macro that returns the current timestamp.

Write a macro that returns 'NULL' if a column is blank or null.

Write a macro that takes a list and returns its comma-separated string.
Input: ['a','b','c'] → Output: 'a, b, c'
/*
-- -> Write a macro that takes a list and returns its comma-separated string.
-- -> Ex :-> Input: ['a','b','c'] → Output: 'a, b, c'
-- > Write a macro that returns a safe column alias (wrapped with double quotes).
-- > Write a macro that dynamically generates order by clause.

*/
{% macro cover_list_to_column(column_list,at_middle,for_order_by,order_method) %}
    {% set columns = '' %}
    {% for column in column_list %}
        {% if loop.first %}
           {% set columns = '"'~ column | upper ~'"' %}
        {% else %}
        {% set columns = columns ~ ',' ~'"'~ column | upper ~'"' %}
        {% endif %}
    {% endfor %}
    {% if at_middle %}
       {% set columns = columns ~',' %}
    {% endif %}
    {% if for_order_by %}
       {% set columns = ' order by ' ~ columns ~ order_method %}
    {% endif %}
    {{ return(columns) }}
{% endmacro %}



Write a macro to generate case dynamically 
/*
 -- -> dynamically generate case statements for multiple conditions
 -- -> if a condition has  multiple expression give user flexibility to use and or clause for that

-- -> input : --
            {
            'first_expression': ['id = 331',' name = "Aditya1"',' sal = 10100'],
            'first_output':"'employee found1'",
            'first_expression_join_by':'and',
            'second_expression': ['id = 332',' name = "Aditya2"',' sal = 10300'],
            'second_output':"'employee found3'",
            'second_expression_join_by':'or',
            'third_expression': ['id = 333',' name = "Aditya3"',' sal = 10400'],
            'third_output':"'employee found4'",
            'third_expression_join_by':'and',
            }
 -- -> for now assume the user will give at least 2 conditions and always mention the join_by value
 -- -> for now assumeing user is not giving else and column_name aliasing
*/

{% macro generate_case(**kwargs)%}
    {% set keys = [] %}
    {% for key in kwargs.keys() %}
        {% if  key[0 : key.find("_")] | lower not in keys %}
          {%set  keys = keys + [key[0 : key.find("_")] | lower] %}
        {% endif%}
     {% endfor %}
     {% set sql_stmt = ' case '%}
     {% for prefix in keys %}
        {% set expression = kwargs.get(prefix ~ '_expression')%}
        {% set join_by =  kwargs.get(prefix ~ '_expression_join_by') %}
        {% set when_expression_joined = '' %}
        {% for ele in expression %}
            {% if loop.first %}
               {% set when_expression_joined =  ele %}
             {% else %}
                {% set when_expression_joined = when_expression_joined ~ ' ' ~ join_by ~ ' ' ~ ele %}
            {% endif%}
        {% endfor %}

        {% set then_value = kwargs.get(prefix ~ '_output') %}
        {% set sql_stmt = sql_stmt ~ ' when ' ~ when_expression_joined ~ ' then '  ~ then_value ~ '   \n '%}
     {% endfor %}
     {% set sql_stmt = sql_stmt ~ ' end '%}
     {{ return(sql_stmt)}}
{% endmacro %}

