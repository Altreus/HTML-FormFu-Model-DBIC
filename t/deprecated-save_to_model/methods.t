use strict;
use warnings;
use Test::More tests => 7;

use HTML::FormFu;
use lib 't/lib';
use DBICTestLib 'new_db';
use MySchema;

new_db();


my $schema = MySchema->connect('dbi:SQLite:dbname=t/test.db');

my $rs = $schema->resultset('Master');
{
    my $form = HTML::FormFu->new;

    $form->load_config_file('t/deprecated-save_to_model/methods.yml');
    # Fake submitted form
    $form->process( {
            method_test => 'apejens',
            method_checkbox_test => 1,
        } );

    {
        my $row = $rs->new( {} );

        $form->save_to_model($row);
    }

    {
        my $row = $rs->find(1);

        is( $row->text_col,             'apejens' );
        is( $row->method_test,          'apejens' );
        is( $row->checkbox_col,         1);
        is( $row->method_checkbox_test, 1);
    }

    }
{
    my $form = HTML::FormFu->new;

    $form->load_config_file('t/deprecated-save_to_model/methods.yml');
    
    $form->process({
        method_test => 'apejens2',
    });
    my $row = $rs->find(1);
    $form->save_to_model($row);
    
    is( $row->text_col,                 'apejens2' );
    is( $row->checkbox_col,             0);
    is( $row->method_checkbox_test,     0);
}
