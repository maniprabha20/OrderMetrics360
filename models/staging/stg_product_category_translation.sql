select
    product_category_name,
    roduct_category_name_english as product_category_name_english
from {{ source('raw', 'product_category_translation') }}
