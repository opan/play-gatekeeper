#!/bin/bash

. gatekeeper/third_party/demo-magic/demo-magic.sh

kubectl apply -f gatekeeper/config/sync.yaml >> /dev/null
kubectl apply -f gatekeeper/sample/existing_resources

clear

NO_WAIT=true
# p "Our cluster called FooPay Cluster has two running pods, which has a problem such as no resource request and limit and no proper labelling in the resource."

# p "This cluster is pre-installed with Gatekeeper so we can skip the gatekeeper installation part. "
# p "First, lets see the current status of our cluster"

p "=== Begin ==="
NO_WAIT=false

pe "kubectl get pods"

# pe "cat gatekeeper/sample/existing_resources/no_required_label.yaml"

# p "I make the pods name obvious so we know what the issue it has"

# p "Now, we will try add a constraint templates to our cluster to address the issues"

# p "Let's see one of the constraint templates how they look like"

pe "kubectl apply -f gatekeeper/sample/templates"

pe "cat gatekeeper/sample/templates/foopayk8srequiredlabels_template.yaml"

# at least there are three main parts in the constraint templates
# first, validation, where we define the schema for the parameters field for the constraint
# second the targets field, where we define what target the constraint to applies to.
# currently only apply to one target.
# third,  rego, where we write rego to define the logic that enforces the constraint.

pe "kubectl apply -f gatekeeper/sample/constraints"

pe "cat gatekeeper/sample/constraints/must_have_required_label.yaml"

# Now let's try to implement some bad resources
pe "kubectl apply -f gatekeeper/sample/bad_resources"

pe "cat gatekeeper/sample/bad_resources/no_required_label.yaml"

pe "kubectl apply -f gatekeeper/sample/good_resources"

p "=== The End ==="

kubectl delete -f gatekeeper/sample/good_resources
kubectl delete -f gatekeeper/sample/existing_resources
kubectl delete -f gatekeeper/sample/constraints
kubectl delete -f gatekeeper/sample/templates
kubectl delete -f gatekeeper/config/sync.yaml
