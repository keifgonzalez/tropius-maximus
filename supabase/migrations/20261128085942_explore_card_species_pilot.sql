-- Search links supplement the catalog. Each printing retains its card ID.
create table public.catalog_card_species (
  species_id integer not null references public.pokemon_metadata(pokedex_number),
  card_id text not null references public.cards(id) on delete cascade,
  evidence text not null check (evidence in ('national_pokedex', 'reviewed_title')),
  primary key (species_id, card_id)
);

create index catalog_card_species_card_id_idx on public.catalog_card_species (card_id);

alter table public.catalog_card_species enable row level security;
revoke all on public.catalog_card_species from public, anon, authenticated;
grant select on public.catalog_card_species to authenticated;
grant select, insert, update, delete on public.catalog_card_species to service_role;

create policy "signed-in species link read" on public.catalog_card_species
for select to authenticated
using ((select auth.role()) = 'authenticated'
       and (select auth.jwt()->>'is_anonymous') is distinct from 'true'
       and exists (select 1 from public.cards as card where card.id = catalog_card_species.card_id));

-- Keep the card columns intact so PostgREST can follow the existing
-- annotation relationship. The image predicate uses the same computed field.
create view public.explore_species_cards with (security_invoker = true) as
  select card.*, link.species_id, public.card_has_image_override(card) as card_has_image_override
  from public.catalog_card_species as link
  join public.cards as card on card.id = link.card_id;

revoke all on public.explore_species_cards from public, anon, authenticated;
grant select on public.explore_species_cards to authenticated, service_role;

notify pgrst, 'reload schema';
