package NewsPackager::DB::Schema::Result::SourceType;

use base 'DBIx::Class::Core';

__PACKAGE__->table('source_type');

__PACKAGE__->add_column(
	source_type_id => {
		data_type => 'integer',
		is_nullable => 0,
		is_auto_increment => 1
	}
);

__PACKAGE__->add_column(
	name => {
		data_type => 'varchar',
	}
);

__PACKAGE__->set_primary_key('source_type_id');

__PACKAGE__->has_many('stories' => 'NewsPackager::DB::Schema::Result::Story', 'source_type');

1;