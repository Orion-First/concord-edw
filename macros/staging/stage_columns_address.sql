 {% macro stage_columns_address(street, street_2, street_3, city, state, zip, county, alias_prefix) -%}
    nullif(left(ltrim(rtrim(ifnull({{ street }} ,''))), 100)::varchar(100),'') as {{ alias_prefix }}street,
    nullif(left(ltrim(rtrim(ifnull({{ street_2 }} ,''))), 100)::varchar(100),'') as {{ alias_prefix }}street_2,
    nullif(left(ltrim(rtrim(ifnull({{ street_3 }} ,''))), 100)::varchar(20),'') as {{ alias_prefix }}street_3,
    left(
        {%- if alias_prefix ~ street_2 is none and alias_prefix ~ street_3 is none -%}
            {{ alias_prefix}}street 
        {%- elif street_2 is none and alias_prefix ~ street_3 is not none %}
            {{ alias_prefix}}street {{ alias_prefix}}street_2 {{ alias_prefix}}street_3)
        {%- elif street_2 is not none %}
            {{ alias_prefix}}{{ street }} {{ alias_prefix}}{{ street_2 }}
        {%- elif alias_prefix ~ street_3 is not none %}
            {{ alias_prefix}}street {{ alias_prefix}}street_3
        {%- else %}
            {{ alias_prefix}}street {{ alias_prefix}}street_2 {{ alias_prefix}}street_3)
        {%- endif -%}
    , 200) as {{ alias_prefix }}street_address,
    nullif(left(ifnull({{ city }}, '')::varchar(75), 75), '') as {{ alias_prefix }}city,
    nullif(left(ifnull({{ state }}, ''), 3), '')::varchar(3) as {{ alias_prefix }}state_code,
    nullif(left(LPAD(ifnull({{ zip }}, ''),5,'0'), 10)::varchar(10), '') {{ alias_prefix }}zip,
    {%- if county == null %}
        null {{ alias_prefix }}county
    {%- else %}
        nullif(left(ifnull({{ county }}, '')::varchar(50), 50), '') as {{ alias_prefix }}county
    {% endif -%}
{%- endmacro -%}    
