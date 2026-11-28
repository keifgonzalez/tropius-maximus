-- A scalar PostgREST projection lets PostgreSQL sort and page cards before
-- reading the annotations needed for the grid. The caller's RLS still applies.
create or replace function public.explore_grid_annotation(public.cards)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select jsonb_build_object(
    'image_override', a.image_override,
    'extra', a.extra,
    'updated_by', a.updated_by,
    'updated_at', a.updated_at
  )
  from public.annotations a
  where a.card_id = $1.id;
$$;

revoke execute on function public.explore_grid_annotation(public.cards) from public, anon;
grant execute on function public.explore_grid_annotation(public.cards) to authenticated, service_role;

notify pgrst, 'reload schema';
