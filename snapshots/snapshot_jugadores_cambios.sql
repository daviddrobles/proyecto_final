{% snapshot jugadores_snapshot_cambios %}

{{
    config(
      target_schema='snapshots',
      unique_key='id',
      strategy='timestamp',
      updated_at='load_at',
    )
}}

select * 
from {{ source('proyecto_final', 'JUGADORES') }} 

{% endsnapshot %}