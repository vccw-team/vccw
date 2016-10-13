<?php

class wfb_createNewRole {

private $role_name  = null;
private $role_display_name = null;
private $template   = null;
private $new_cap    = array();

function __construct(
    $name,
    $title,
    $template = null,
    $new_cap = array()
)
{
    $this->role_name    = $name;
    $this->role_display_name   = $title;
    $this->template     = $template;
    $this->new_cap      = $new_cap;
    $this->create();
}

public function create()
{
    if (add_role($this->role_name, $this->role_display_name)):
        $role = get_role($this->role_name);
        if ($this->template) {
            $template = get_role($this->template);
            foreach ($template->capabilities as $cap => $value) {
                if ($value) {
                    $role->add_cap($cap);
                }
            }
        }
        foreach ($this->new_cap as $cap) {
            $role->add_cap($cap);
        }
    endif;
}
}

?>
